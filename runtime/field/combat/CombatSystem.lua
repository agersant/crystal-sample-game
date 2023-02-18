local CombatData = require("field/combat/CombatData");
local DamageEvent = require("field/combat/damage/DamageEvent");
local DamageIntent = require("field/combat/damage/DamageIntent");
local DeathEvent = require("field/combat/damage/DeathEvent");
local HitEvent = require("field/combat/HitEvent");
local Teams = require("field/combat/Teams");
local Actor = require("mapscene/behavior/Actor");
local InputListener = require("mapscene/behavior/InputListener");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Locomotion = require("mapscene/physics/Locomotion");

local CombatSystem = Class("CombatSystem", crystal.System);

CombatSystem.init = function(self)
	self._scriptRunnerQuery = self:add_query({ ScriptRunner });
	self._locomotionQuery = self:add_query({ CombatData, Locomotion });
	self._inputQuery = self:add_query({ CombatData, InputListener });
end

CombatSystem.beforeScripts = function(self, dt)
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

CombatSystem.duringScripts = function(self, dt)
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
			victim:signalAllScripts("disrupted");
			for _, onHitEffect in ipairs(damageEvent:getOnHitEffects()) do
				onHitEffect:apply(attacker, victim, effectiveDamage);
			end
			victim:signalAllScripts("receivedDamage", effectiveDamage);
		end
	end

	local deathEvents = self:ecs():events(DeathEvent);
	for _, deathEvent in ipairs(deathEvents) do
		local victim = deathEvent:entity();
		if self._scriptRunnerQuery:contains(victim) then
			local scriptRunner = victim:component(ScriptRunner);
			scriptRunner:signalAllScripts("died");
		end
		if self._inputQuery:contains(victim) then
			local inputListener = victim:component(InputListener);
			inputListener:disable();
		end
	end
end

return CombatSystem;
