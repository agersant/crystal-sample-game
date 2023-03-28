local Warrior = Class("Warrior", crystal.Entity);

local hitReactions = function(self)
	while true do
		self:wait_for("died");
		self:stopAction();
		self:doAction(function(self)
			self:set_animation("death");
			self:hang();
		end);
	end
end

Warrior.init = function(self)
	self:add_component(crystal.AnimatedSprite, crystal.assets.get("assets/sprite/duran.lua"));
	self:add_component("YDrawOrder");
	self:add_component("CommonShader");
	self:add_component("CardinalDirection");
	self:add_component("FlinchAnimation", "knockback");
	self:add_component("IdleAnimation", "idle");
	self:add_component("WalkAnimation", "walk");
	self:add_component("Altitude");

	self:add_component("ScriptRunner");
	self:add_component("Actor");

	self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(6));
	self:set_categories("solid");
	self:enable_collision_with("solid", "trigger");
	self:add_component(crystal.Movement);

	self:add_component("CombatData");
	self:add_component("DamageIntent");

	self:add_component("HitBlink");
	self:add_component("Flinch");

	self:add_component("ComboAttack", 1);
	self:add_component("Dash", 2);

	self:add_script(hitReactions);
end

return Warrior;
