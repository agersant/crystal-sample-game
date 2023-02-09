local TargetSelector = require("field/combat/ai/TargetSelector");
local CombatData = require("field/combat/CombatData");
local DamageUnit = require("field/combat/damage/DamageUnit");
local CombatHitbox = require("field/combat/CombatHitbox");
local DamageIntent = require("field/combat/damage/DamageIntent");
local Flinch = require("field/combat/hit-reactions/Flinch");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");
local HitBlink = require("field/combat/hit-reactions/HitBlink");
local FlinchAnimation = require("field/animation/FlinchAnimation");
local IdleAnimation = require("field/animation/IdleAnimation");
local WalkAnimation = require("field/animation/WalkAnimation");
local CommonShader = require("graphics/CommonShader");
local Navigation = require("mapscene/behavior/ai/Navigation");
local Entity = require("ecs/Entity");
local Actor = require("mapscene/behavior/Actor");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Sprite = require("mapscene/display/Sprite");
local SpriteAnimator = require("mapscene/display/SpriteAnimator");
local Collision = require("mapscene/physics/Collision");
local Locomotion = require("mapscene/physics/Locomotion");
local PhysicsBody = require("mapscene/physics/PhysicsBody");
local Weakbox = require("mapscene/physics/Weakbox");
local Script = require("script/Script");

local Sahagin = Class("Sahagin", Entity);

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
	local sprite = self:addComponent(Sprite:new());
	self:addComponent(SpriteAnimator:new(sprite, sheet));
	self:addComponent(CommonShader:new());
	self:addComponent(FlinchAnimation:new("knockback"));
	self:addComponent(IdleAnimation:new("idle"));
	self:addComponent(WalkAnimation:new("walk"));

	self:addComponent(ScriptRunner:new());
	self:addComponent(Actor:new());

	local physicsBody = self:addComponent(PhysicsBody:new(scene:getPhysicsWorld(), "dynamic"));
	self:addComponent(Locomotion:new());
	self:addComponent(Navigation:new());
	self:addComponent(Collision:new(physicsBody, 4));

	self:addComponent(CombatData:new());
	self:addComponent(DamageIntent:new());
	self:addComponent(CombatHitbox:new(physicsBody));
	self:addComponent(Weakbox:new(physicsBody));
	self:addComponent(TargetSelector:new());

	self:addComponent(Flinch:new());
	self:addComponent(HitBlink:new());

	local ai = self:addScript(Script:new(ai));
	ai:addThread(handleDeath);
end

return Sahagin;
