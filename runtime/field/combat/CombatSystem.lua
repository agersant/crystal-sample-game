local CombatData = require("field/combat/CombatData");
local DamageEvent = require("field/combat/damage/DamageEvent");
local DamageIntent = require("field/combat/damage/DamageIntent");
local DeathEvent = require("field/combat/damage/DeathEvent");
local HitEvent = require("field/combat/HitEvent");
local Teams = require("field/combat/Teams");

local CombatSystem = Class("CombatSystem", crystal.System);

CombatSystem.init = function(self)
	self._scriptRunnerQuery = self:add_query({ crystal.ScriptRunner });
	self._movementQuery = self:add_query({ CombatData, crystal.Movement });
	self.with_animated_hitbox = self:add_query({ crystal.Body, crystal.AnimatedSprite });
end

CombatSystem.before_run_scripts = function(self, dt)
	local entities = self._movementQuery:entities();
	for entity in pairs(entities) do
		local actor = entity:component("Actor");
		if not actor or actor:isIdle() then
			local movement = entity:component(crystal.Movement);
			local combatData = entity:component(CombatData);
			local speed = combatData:getMovementSpeed();
			movement:set_speed(speed);
		end
	end
end

CombatSystem.run_scripts = function(self, dt)
	local hitEvents = self:ecs():events(HitEvent);
	for _, hitEvent in ipairs(hitEvents) do
		local attacker = hitEvent:entity();
		local victim = hitEvent:getTargetEntity();
		if attacker:component(CombatData) and victim:component(CombatData) then
			if Teams:areEnemies(attacker:getTeam(), victim:getTeam()) then
				local damageIntent = attacker:component(DamageIntent);
				local attackerCombatData = attacker:component(CombatData);
				local victimCombatData = victim:component(CombatData);
				if damageIntent and attackerCombatData and victimCombatData then
					if not damageIntent:wasEntityHit(victim) then
						damageIntent:registerHit(victim);
						attackerCombatData:inflictDamage(damageIntent, victimCombatData);
					end
				end
			end
		end
	end

	local damageEvents = self:ecs():events(DamageEvent);
	for _, damageEvent in ipairs(damageEvents) do
		local victim = damageEvent:entity();
		if self._scriptRunnerQuery:contains(victim) then
			local attacker = damageEvent:getAttacker();
			assert(attacker);
			local effectiveDamage = damageEvent:getDamage();
			assert(effectiveDamage);
			victim:signal_all_scripts("disrupted");
			for _, onHitEffect in ipairs(damageEvent:getOnHitEffects()) do
				onHitEffect:apply(attacker, victim, effectiveDamage);
			end
			victim:signal_all_scripts("receivedDamage", effectiveDamage);
		end
	end

	local deathEvents = self:ecs():events(DeathEvent);
	for _, deathEvent in ipairs(deathEvents) do
		local victim = deathEvent:entity();
		if self._scriptRunnerQuery:contains(victim) then
			local scriptRunner = victim:component(crystal.ScriptRunner);
			scriptRunner:signal_all_scripts("died");
		end
	end
end

CombatSystem.after_run_scripts = function(self, dt)
	local entities = self.with_animated_hitbox:entities();
	for entity in pairs(entities) do
		if entity:is_valid() then
			for hitbox in pairs(entity:components("Hitbox")) do
				entity:remove_component(hitbox);
			end
			for weakbox in pairs(entity:components("Weakbox")) do
				entity:remove_component(weakbox);
			end

			local animated_sprite = entity:component("AnimatedSprite");
			local shape = animated_sprite:sprite_hitbox("hit");
			if shape then
				entity:add_component("Hitbox", shape);
			end
			local shape = animated_sprite:sprite_hitbox("weak");
			if shape then
				entity:add_component("Weakbox", shape);
			end
		end
	end
end

return CombatSystem;
