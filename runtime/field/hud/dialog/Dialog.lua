local Behavior = require("mapscene/behavior/Behavior");
local InputListener = require("mapscene/behavior/InputListener");

local Dialog = Class("Dialog", Behavior);

Dialog.init = function(self, dialogBox)
	Dialog.super.init(self);
	assert(dialogBox);
	self._dialogBox = dialogBox;
	self._inputListener = nil;
	self._inputContext = nil;

	local dialog = self;
	self._script:addThread(function(self)
		self:scope(function()
			dialog:cleanup();
		end);
		self:hang();
	end);
end

Dialog.beginDialog = function(self, player)
	assert(player);
	assert(player:is_instance_of(crystal.Entity));
	assert(player:component(InputListener));
	assert(not self._inputListener);
	assert(not self._inputContext);
	if self._dialogBox:open() then
		self._inputListener = player:component(InputListener);
		self._inputContext = self._inputListener:pushContext(self._script);
		return true;
	end
	return false;
end

Dialog.sayLine = function(self, text)
	assert(text);
	assert(self._inputListener);
	assert(self._inputContext);

	local inputListener = self._inputListener;
	local inputContext = self._inputContext;
	local dialogBox = self._dialogBox;

	local waitForInput = function(self)
		if inputListener:isCommandActive("advanceDialog", inputContext) then
			self:waitFor("-advanceDialog");
		end
		self:waitFor("+advanceDialog");
	end

	local lineDelivery = self._script:addThreadAndRun(function(self)
		self:thread(function()
			waitForInput(self);
			dialogBox:fastForward(text);
		end);

		self:join(dialogBox:sayLine(text));
		waitForInput(self);
	end);

	return lineDelivery;
end

Dialog.cleanup = function(self)
	if self._inputListener or self._inputContext then
		self:endDialog();
	end
end

Dialog.endDialog = function(self)
	assert(self._inputListener);
	assert(self._inputContext);
	self._dialogBox:close();
	self._inputListener:popContext(self._inputContext);
	self._inputListener = nil;
	self._inputContext = nil;
end

--#region Tests

local MapScene = require("mapscene/MapScene");
local InputDevice = require("input/InputDevice");
local Script = require("script/Script");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local PhysicsBody = require("mapscene/physics/PhysicsBody");
local DialogBox = require("field/hud/dialog/DialogBox");

crystal.test.add("Blocks script during dialog", function()
	local scene = MapScene:new("test-data/empty_map.lua");

	local dialogBox = DialogBox:new();

	local player = scene:spawn(crystal.Entity);

	local inputDevice = InputDevice:new(1);
	inputDevice:addBinding("advanceDialog", "q");
	player:add_component(InputListener, inputDevice);

	player:add_component(ScriptRunner);
	player:add_component(PhysicsBody, scene:getPhysicsWorld());

	local npc = scene:spawn(crystal.Entity);
	npc:add_component(ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	local a;
	npc:addScript(Script:new(function(self)
		a = 1;
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
		a = 2;
	end));

	local frame = function(self)
		scene:update(0);
		dialogBox:update(0);
		inputDevice:flushEvents();
	end

	frame();
	assert(a == 1);

	inputDevice:keyPressed("q");
	frame();
	inputDevice:keyReleased("q");
	frame();
	inputDevice:keyPressed("q");
	frame();
	inputDevice:keyReleased("q");
	frame();

	assert(a == 2);
end);

crystal.test.add("Can't start concurrent dialogs", function()
	local scene = MapScene:new("test-data/empty_map.lua");

	local dialogBox = DialogBox:new();

	local player = scene:spawn(crystal.Entity);

	local inputDevice = InputDevice:new(1);
	inputDevice:addBinding("advanceDialog", "q");
	player:add_component(InputListener, inputDevice);

	player:add_component(ScriptRunner);
	player:add_component(PhysicsBody, scene:getPhysicsWorld());

	local npc = scene:spawn(crystal.Entity);
	npc:add_component(ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	npc:addScript(Script:new(function(self)
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
		self:endDialog();
	end));

	local inputDevice = player:getInputDevice();
	local frame = function(self)
		scene:update(0);
		dialogBox:update(0);
		inputDevice:flushEvents();
	end

	frame();
	assert(not Dialog:new(dialogBox):beginDialog(player));
	inputDevice:keyPressed("q");
	frame();
	inputDevice:keyReleased("q");
	frame();
	inputDevice:keyPressed("q");
	frame();
	inputDevice:keyReleased("q");
	frame();
	assert(Dialog:new(dialogBox):beginDialog(player));
end);

crystal.test.add("Dialog is cleaned up if entity despawns while speaking", function()
	local scene = MapScene:new("test-data/empty_map.lua");

	local dialogBox = DialogBox:new();

	local player = scene:spawn(crystal.Entity);

	local inputDevice = InputDevice:new(1);
	inputDevice:addBinding("advanceDialog", "q");
	player:add_component(InputListener, inputDevice);

	player:add_component(ScriptRunner);
	player:add_component(PhysicsBody, scene:getPhysicsWorld());

	local npc = scene:spawn(crystal.Entity);
	npc:add_component(ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	npc:addScript(Script:new(function(self)
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
	end));

	local inputDevice = player:getInputDevice();
	local frame = function(self)
		scene:update(0);
		dialogBox:update(0);
		inputDevice:flushEvents();
	end

	frame();
	assert(not Dialog:new(dialogBox):beginDialog(player));
	npc:despawn();
	frame();
	assert(Dialog:new(dialogBox):beginDialog(player));
end);

--#endregion

return Dialog;
