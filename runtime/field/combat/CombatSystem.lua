local CombatData = require("field/combat/CombatData");
local DamageEvent = require("field/combat/damage/DamageEvent");
local DamageIntent = require("field/combat/damage/DamageIntent");
local DeathEvent = require("field/combat/damage/DeathEvent");
local HitEvent = require("field/combat/HitEvent");
local Teams = require("field/combat/Teams");
local Actor = require("mapscene/behavior/Actor");
local Locomotion = require("mapscene/physics/Locomotion");

local CombatSystem = Class("CombatSystem", crystal.System);

CombatSystem.init = function(self)
	self._scriptRunnerQuery = self:add_query({ crystal.ScriptRunner });
	self._locomotionQuery = self:add_query({ CombatData, Locomotion });
end

CombatSystem.before_scripts = function(self, dt)
	local entities = self._locomotionQuery:entities();
	for entity in pairs(entities) do
		local actor = entity:component(Actor);
		if not actor or actor:isIdle() then
			local locomotion = entity:component(Locomotion);
			local combatData = entity:component(CombatData);
			local speed = combatData:getMovementSpeed();
			locomotion:setSpeed(speed);
		end
	end
end

CombatSystem.during_scripts = function(self, dt)
	local hitEvents = self:ecs():events(HitEvent);
	for _, hitEvent in ipairs(hitEvents) do
		local attacker = hitEvent:entity();
		local victim = hitEvent:getTargetEntity();
		if Teams:areEnemies(attacker:getTeam(), victim:getTeam()) then
			local damageIntent = attacker:component(DamageIntent);
			local attackerCombatData = attacker:component(CombatData);
			local victimCombatData = victim:component(CombatData);
			if damageIntent and attackerCombatData and victimCombatData then
				attackerCombatData:inflictDamage(damageIntent, victimCombatData);
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

return CombatSystem;
