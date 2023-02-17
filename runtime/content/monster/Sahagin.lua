local Navigation = require("mapscene/behavior/ai/Navigation");
local DamageUnit = require("field/combat/damage/DamageUnit");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");
local Script = require("script/Script");

local Sahagin = Class("Sahagin", crystal.Entity);

local attack = function(self)
	self:endOn("disrupted");
	self:setMovementAngle(nil);
	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new() };
	self:setDamagePayload({ DamageUnit:new(10) }, onHitEffects);
	self:join(self:playAnimation("attack", self:getAngle4(), true));
end

local reachAndAttack = function(self)
	self:endOn("disrupted");
	self:endOn("died");

	local target = self:getNearestEnemy();
	if not target then
		self:waitFrame();
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
			self:waitFor("idle");
		end
		if self:isDead() then
			break
		end
		local taskThread = self:thread(reachAndAttack);
		self:join(taskThread);
		self:waitFrame();
	end
end

local handleDeath = function(self)
	while true do
		self:waitFor("died");
		self:stopAction();
		self:doAction(function(self)
			self:setAnimation("smashed");
			self:wait(2);
			self:despawn();
			self:waitFrame();
		end);
	end
end

Sahagin.init = function(self, scene)
	Sahagin.super.init(self, scene);

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

	local ai = self:addScript(Script:new(ai));
	ai:addThread(handleDeath);
end

return Sahagin;
