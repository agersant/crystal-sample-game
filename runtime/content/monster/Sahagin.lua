local Navigation = require("mapscene/behavior/ai/Navigation");
local DamageUnit = require("field/combat/damage/DamageUnit");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");

local Sahagin = Class("Sahagin", crystal.Entity);

local attack = function(self)
	self:stop_on("disrupted");
	self:set_heading(nil);
	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new() };
	self:setDamagePayload({ DamageUnit:new(2) }, onHitEffects);
	self:join(self:playAnimation("attack", self:rotation(), true));
end

local reachAndAttack = function(self)
	self:stop_on("disrupted");
	self:stop_on("died");

	local target = self:getNearestEnemy();
	if not target then
		self:wait_frame();
		return;
	end

	if not self:join(self:navigateToEntity(target, 30)) then
		return;
	end

	if not self:join(self:alignWithEntity(target, 2)) then
		return;
	end

	self:look_at(target:position());
	self:wait(0.2);
	self:look_at(target:position());

	if not self:isIdle() then
		return;
	end
	local actionThread = self:doAction(attack);
	if self:join(actionThread) then
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
		local taskThread = self:thread(reachAndAttack);
		self:join(taskThread);
		self:wait_frame();
	end
end

local handleDeath = function(self)
	while true do
		self:wait_for("died");
		self:stopAction();
		self:doAction(function(self)
			self:setAnimation("smashed");
			self:wait(2);
			self:despawn();
			self:wait_frame();
		end);
	end
end

Sahagin.init = function(self)
	local scene = self:ecs();

	local sheet = crystal.assets.get("assets/sprite/sahagin.lua");
	local sprite = self:add_component("Sprite");
	self:add_component("SpriteAnimator", sprite, sheet);
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
	self:add_component("Navigation");

	self:add_component("CombatData");
	self:add_component("DamageIntent");
	self:add_component("TargetSelector");

	self:add_component("Flinch");
	self:add_component("HitBlink");

	local ai = self:add_script(ai);
	ai:add_thread(handleDeath);
end

return Sahagin;
