local IdleAnimation = require("field/animation/IdleAnimation");
local Dialog = require("field/hud/dialog/Dialog");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Sprite = require("mapscene/display/Sprite");
local SpriteAnimator = require("mapscene/display/SpriteAnimator");
local Collision = require("mapscene/physics/Collision");
local PhysicsBody = require("mapscene/physics/PhysicsBody");
local Script = require("script/Script");

local NPC = Class("NPC", crystal.Entity);

local script = function(self)
	while true do
		local player = self:waitFor("interact");
		if self:beginDialog(player) then
			self:join(self:sayLine(
				"The harvest this year was meager, there is no spare bread for a stranger like you. If I cannot feed my children, why would I feed you? Extra lines of text to get to line four, come on just a little more."));
			self:join(self:sayLine("Now leave this town before things go awry, please."));
			self:endDialog();
		end
	end
end

NPC.init = function(self, scene)
	NPC.super.init(self, scene);
	local sheet = ASSETS:getSpritesheet("assets/spritesheet/sahagin.lua");
	local sprite = self:add_component(Sprite);
	self:add_component(SpriteAnimator, sprite, sheet);
	self:add_component(IdleAnimation, "idle");

	local physicsBody = self:add_component(PhysicsBody, scene:getPhysicsWorld());
	self:add_component(Collision, physicsBody, 4);
	self:add_component(ScriptRunner);
	self:add_component(Dialog, scene:getHUD():getDialogBox());
	self:addScript(Script:new(script));
end

return NPC;
