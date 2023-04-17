local Dialog = Class("Dialog", crystal.Behavior);

Dialog.init = function(self, dialogBox)
	Dialog.super.init(self);
	assert(dialogBox);
	self._dialogBox = dialogBox;
end

Dialog.beginDialog = function(self, player)
	assert(player);
	assert(player:inherits_from(crystal.Entity));
	local dialog_box = self._dialogBox;
	if dialog_box:open() then
		self:script():run_thread(function(self)
			self:defer(function()
				dialog_box:close();
			end);
			self:defer(player:disable_movement());
			self:defer(player:add_input_handler(function(input)
				self:signal(input);
				return true;
			end));
			self:hang();
		end);
		return true;
	end
	return false;
end

Dialog.sayLine = function(self, text)
	assert(text);
	local dialogBox = self._dialogBox;
	local lineDelivery = self:script():run_thread(function(self)
		self:thread(function(self)
			self:wait_frame();
			self:wait_for("+advanceDialog");
			dialogBox:fastForward(text);
		end);

		self:join(dialogBox:sayLine(text));
		self:wait_for("+advanceDialog");
	end);
	return lineDelivery;
end

Dialog.endDialog = function(self)
	self._dialogBox:close();
	self:script():stop_all_threads();
end

--#region Tests

local DialogBox = require("field/hud/dialog/DialogBox");

crystal.test.add("Blocks script during dialog", function()
	local world = require("field/Field"):new("assets/map/empty_map.lua");
	local dialogBox = DialogBox:new();
	local input_player = crystal.input.player(1);
	input_player:set_bindings({ q = { "advanceDialog" } });

	local player = world:spawn(crystal.Entity);
	player:add_component(crystal.InputListener, input_player);
	player:add_component(crystal.ScriptRunner);
	player:add_component(crystal.Movement);
	player:add_component(crystal.Body);

	local npc = world:spawn(crystal.Entity);
	npc:add_component(crystal.ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	local a;
	npc:add_script(function(self)
		a = 1;
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
		a = 2;
	end);

	local frame = function(self)
		world:update(0);
		dialogBox:update(0);
		input_player:flush_events();
	end

	frame();
	assert(a == 1);

	input_player:key_pressed("q");
	frame();
	input_player:key_released("q");
	frame();
	input_player:key_pressed("q");
	frame();
	input_player:key_released("q");
	frame();

	assert(a == 2);
end);

crystal.test.add("Can't start concurrent dialogs", function()
	local world = require("field/Field"):new("assets/map/empty_map.lua");
	local dialogBox = DialogBox:new();
	local input_player = crystal.input.player(1);
	input_player:set_bindings({ q = { "advanceDialog" } });

	local player = world:spawn(crystal.Entity);
	player:add_component(crystal.InputListener, input_player);
	player:add_component(crystal.ScriptRunner);
	player:add_component(crystal.Movement);
	player:add_component(crystal.Body);

	local npc = world:spawn(crystal.Entity);
	npc:add_component(crystal.ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	npc:add_script(function(self)
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
		self:endDialog();
	end);

	local frame = function(self)
		world:update(0);
		dialogBox:update(0);
		input_player:flush_events();
	end

	frame();
	assert(not Dialog:new(dialogBox):beginDialog(player));
	input_player:key_pressed("q");
	frame();
	input_player:key_released("q");
	frame();
	input_player:key_pressed("q");
	frame();
	input_player:key_released("q");
	frame();
	assert(Dialog:new(dialogBox):beginDialog(player));
end);

crystal.test.add("Dialog is cleaned up if entity despawns while speaking", function()
	local world = require("field/Field"):new("assets/map/empty_map.lua");
	local dialogBox = DialogBox:new();
	local input_player = crystal.input.player(1);
	input_player:set_bindings({ q = { "advanceDialog" } });

	local player = world:spawn(crystal.Entity);
	player:add_component(crystal.InputListener, input_player);
	player:add_component(crystal.ScriptRunner);
	player:add_component(crystal.Movement);
	player:add_component(crystal.Body);

	local npc = world:spawn(crystal.Entity);
	npc:add_component(crystal.ScriptRunner);
	npc:add_component(Dialog, dialogBox);

	npc:add_script(function(self)
		self:beginDialog(player);
		self:join(self:sayLine("Test dialog."));
	end);

	local frame = function(self)
		world:update(0);
		dialogBox:update(0);
		input_player:flush_events();
	end

	frame();
	assert(not Dialog:new(dialogBox):beginDialog(player));
	npc:despawn();
	frame();
	assert(Dialog:new(dialogBox):beginDialog(player));
end);

--#endregion

return Dialog;
