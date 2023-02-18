local Script = require("script/Script");

local Warrior = Class("Warrior", crystal.Entity);

local hitReactions = function(self)
	while true do
		self:waitFor("died");
		self:stopAction();
		self:doAction(function(self)
			self:setAnimation("death");
			self:hang();
		end);
	end
end

Warrior.init = function(self)
	local scene = self:ecs();
	local sheet = ASSETS:getSpritesheet("assets/spritesheet/duran.lua");
	local sprite = self:add_component("Sprite");
	self:add_component("SpriteAnimator", sprite, sheet);
	self:add_component("CommonShader");
	self:add_component("FlinchAnimation", "knockback");
	self:add_component("IdleAnimation", "idle");
	self:add_component("WalkAnimation", "walk");

	self:add_component("ScriptRunner");
	self:add_component("Actor");

	local physicsBody = self:add_component("PhysicsBody", scene:getPhysicsWorld(), "dynamic");
	self:add_component("Locomotion");
	self:add_component("Collision", physicsBody, 6);

	self:add_component("CombatData");
	self:add_component("DamageIntent");
	self:add_component("CombatHitbox", physicsBody);
	self:add_component("Weakbox", physicsBody);

	self:add_component("HitBlink");
	self:add_component("Flinch");

	self:add_component("ComboAttack", 1);
	self:add_component("Dash", 2);

	self:addScript(Script:new(hitReactions));
end

return Warrior;
