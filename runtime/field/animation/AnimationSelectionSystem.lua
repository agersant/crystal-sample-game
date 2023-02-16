local FlinchAnimation = require("field/animation/FlinchAnimation");
local IdleAnimation = require("field/animation/IdleAnimation");
local WalkAnimation = require("field/animation/WalkAnimation");
local Flinch = require("field/combat/hit-reactions/Flinch");
local Actor = require("mapscene/behavior/Actor");
local SpriteAnimator = require("mapscene/display/SpriteAnimator");
local Locomotion = require("mapscene/physics/Locomotion");
local PhysicsBody = require("mapscene/physics/PhysicsBody");

local AnimationSelectionSystem = Class("AnimationSelectionSystem", crystal.System);

AnimationSelectionSystem.init = function(self, ecs)
	AnimationSelectionSystem.super.init(self, ecs);
	self._idles = self:ecs():add_query({ SpriteAnimator, PhysicsBody, IdleAnimation });
	self._walks = self:ecs():add_query({ SpriteAnimator, PhysicsBody, Locomotion, WalkAnimation });
	self._flinches = self:ecs():add_query({ SpriteAnimator, PhysicsBody, Flinch, FlinchAnimation });
end

AnimationSelectionSystem.afterScripts = function(self)
	local walkEntities = self._walks:entities();
	local idleEntities = self._idles:entities();
	local flinchEntities = self._flinches:entities();

	-- FLINCH
	for entity in pairs(flinchEntities) do
		local flinch = entity:component(Flinch);
		if flinch:getFlinchAmount() then
			local flinchAnimation = entity:component(FlinchAnimation);
			local animation = flinchAnimation:getFlinchAnimation();
			if animation then
				local animator = entity:component(SpriteAnimator);
				local physicsBody = entity:component(PhysicsBody);
				animator:setAnimation(animation, physicsBody:getAngle4());
				walkEntities[entity] = nil;
				idleEntities[entity] = nil;
			end
		end
	end

	-- WALK
	for entity in pairs(walkEntities) do
		local locomotion = entity:component(Locomotion);
		if locomotion:getMovementAngle() then
			local actor = entity:component(Actor);
			local walkAnimation = entity:component(WalkAnimation);
			if not actor or actor:isIdle() then
				local animation = walkAnimation:getWalkAnimation();
				if animation then
					local animator = entity:component(SpriteAnimator);
					local physicsBody = entity:component(PhysicsBody);
					animator:setAnimation(animation, physicsBody:getAngle4());
					idleEntities[entity] = nil;
				end
			end
		end
	end

	-- IDLE
	for entity in pairs(idleEntities) do
		local actor = entity:component(Actor);
		local idleAnimation = entity:component(IdleAnimation);
		if not actor or actor:isIdle() then
			local animation = idleAnimation:getIdleAnimation();
			if animation then
				local animator = entity:component(SpriteAnimator);
				local physicsBody = entity:component(PhysicsBody);
				animator:setAnimation(animation, physicsBody:getAngle4());
			end
		end
	end
end

return AnimationSelectionSystem;
