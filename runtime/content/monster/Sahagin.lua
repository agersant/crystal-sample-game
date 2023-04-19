local DamageUnit = require("field/combat/damage/DamageUnit");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");
local Stats = require("field/combat/stats/Stats");

local Sahagin = Class("Sahagin", crystal.Entity);

local attack = function(self)
	self:stop_on("disrupted");
	self:set_heading(nil);
	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new() };
	self:setDamagePayload({ DamageUnit:new(2) }, onHitEffects);
	self:play_animation("attack", self:rotation(), true):block();
end

local reachAndAttack = function(self)
	self:stop_on("disrupted");
	self:stop_on("died");

	local target = self:getNearestEnemy();
	if not target then
		self:wait_frame();
		return;
	end

	if not self:navigate_to_entity(target, 30):block() then
		return;
	end

	if not self:align_with_entity(target, 2):block() then
		return;
	end

	self:look_at(target:position());
	self:wait(0.2);
	self:look_at(target:position());

	if not self:isIdle() then
		return;
	end
	local actionThread = self:doAction(attack);
	if actionThread:block() then
		self:wait(.5 + 2 * math.random());
	end
end

local ai = function(self)
	while true do
		while not self:isIdle() do
			self:wait_for("idle");
		end
		if self:isDead() then
			break
		end
		self:thread(reachAndAttack):block();
		self:wait_frame();
	end
end

local handleDeath = function(self)
	while true do
		self:wait_for("died");
		self:stopAction();
		self:doAction(function(self)
			self:set_animation("smashed");
			self:wait(2);
			self:despawn();
			self:wait_frame();
		end);
	end
end

Sahagin.init = function(self)
	local scene = self:ecs();

	self:add_component(crystal.AnimatedSprite, crystal.assets.get("assets/sprite/sahagin.lua"));
	self:add_component("YDrawOrder");
	self:add_component("CommonShader");
	self:add_component("FlinchAnimation", "knockback");
	self:add_component("IdleAnimation", "idle");
	self:add_component("WalkAnimation", "walk");
	self:add_component("Altitude");

	self:add_component("ScriptRunner");
	self:add_component("Actor");

	self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(4));
	self:set_categories("solid");
	self:enable_collision_with("solid");

	self:add_component(crystal.Movement);
	self:add_component(crystal.Navigation, self:context("map"));

	self:add_component("CombatData");
	self:getStat(Stats.MOVEMENT_SPEED):setBaseValue(75);
	self:add_component("DamageIntent");
	self:add_component("TargetSelector");

	self:add_component("Flinch");
	self:add_component("HitBlink");

	local ai = self:add_script(ai);
	ai:add_thread(handleDeath);
end

return Sahagin;
