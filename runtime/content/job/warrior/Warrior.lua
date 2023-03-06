local Warrior = Class("Warrior", crystal.Entity);

local hitReactions = function(self)
	while true do
		self:wait_for("died");
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
	self:add_component("Altitude");

	self:add_component("ScriptRunner");
	self:add_component("Actor");

	local body = self:add_component(crystal.Body, scene:physics_world(), "dynamic");
	self:add_component(crystal.Movement);
	local collider = self:add_component(crystal.Collider, body, love.physics.newCircleShape(6));
	collider:set_categories("solid");
	collider:enable_collision_with("solid", "trigger");

	self:add_component("CombatData");
	self:add_component("DamageIntent");

	self:add_component("HitBlink");
	self:add_component("Flinch");

	self:add_component("ComboAttack", 1);
	self:add_component("Dash", 2);

	self:add_script(hitReactions);
end

return Warrior;
