local Navigation = require("mapscene/behavior/ai/Navigation");
local DamageUnit = require("field/combat/damage/DamageUnit");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");

local Sahagin = Class("Sahagin", crystal.Entity);

local attack = function(self)
	self:end_on("disrupted");
	self:setMovementAngle(nil);
	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new() };
	self:setDamagePayload({ DamageUnit:new(10) }, onHitEffects);
	self:join(self:playAnimation("attack", self:getAngle4(), true));
end

local reachAndAttack = function(self)
	self:end_on("disrupted");
	self:end_on("died");

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

	self:lookAt(target:getPosition());
	self:wait(0.2);
	self:lookAt(target:getPosition());

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

	local sheet = ASSETS:getSpritesheet("assets/spritesheet/sahagin.lua");
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
	self:add_component("Navigation");
	self:add_component("Collision", physicsBody, 4);

	self:add_component("CombatData");
	self:add_component("DamageIntent");
	self:add_component("CombatHitbox", physicsBody);
	self:add_component("Weakbox", physicsBody);
	self:add_component("TargetSelector");

	self:add_component("Flinch");
	self:add_component("HitBlink");

	local ai = self:add_script(crystal.Script:new(ai));
	ai:add_thread(handleDeath);
end

return Sahagin;
