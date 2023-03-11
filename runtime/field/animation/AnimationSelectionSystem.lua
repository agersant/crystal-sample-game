local FlinchAnimation = require("field/animation/FlinchAnimation");
local IdleAnimation = require("field/animation/IdleAnimation");
local WalkAnimation = require("field/animation/WalkAnimation");
local Flinch = require("field/combat/hit-reactions/Flinch");
local SpriteAnimator = require("mapscene/display/SpriteAnimator");

local AnimationSelectionSystem = Class("AnimationSelectionSystem", crystal.System);

AnimationSelectionSystem.init = function(self)
	self._idles = self:add_query({ SpriteAnimator, crystal.Body, IdleAnimation });
	self._walks = self:add_query({ SpriteAnimator, crystal.Body, crystal.Movement, WalkAnimation });
	self._flinches = self:add_query({ SpriteAnimator, crystal.Body, Flinch, FlinchAnimation });
end

AnimationSelectionSystem.after_run_scripts = function(self)
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
				local body = entity:component(crystal.Body);
				animator:setAnimation(animation, body:angle4());
				walkEntities[entity] = nil;
				idleEntities[entity] = nil;
			end
		end
	end

	-- WALK
	for entity in pairs(walkEntities) do
		local movement = entity:component(crystal.Movement);
		if movement:heading() and movement:is_movement_enabled() then
			local actor = entity:component("Actor");
			local walkAnimation = entity:component(WalkAnimation);
			if not actor or actor:isIdle() then
				local animation = walkAnimation:getWalkAnimation();
				if animation then
					local animator = entity:component(SpriteAnimator);
					local body = entity:component(crystal.Body);
					animator:setAnimation(animation, body:angle4());
					idleEntities[entity] = nil;
				end
			end
		end
	end

	-- IDLE
	for entity in pairs(idleEntities) do
		local actor = entity:component("Actor");
		local idleAnimation = entity:component(IdleAnimation);
		if not actor or actor:isIdle() then
			local animation = idleAnimation:getIdleAnimation();
			if animation then
				local animator = entity:component(SpriteAnimator);
				local body = entity:component(crystal.Body);
				animator:setAnimation(animation, body:angle4());
			end
		end
	end
end

return AnimationSelectionSystem;
