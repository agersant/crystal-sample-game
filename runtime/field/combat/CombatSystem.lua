local CombatData = require("field/combat/CombatData");
local DamageEvent = require("field/combat/damage/DamageEvent");
local DamageIntent = require("field/combat/damage/DamageIntent");
local DeathEvent = require("field/combat/damage/DeathEvent");
local HitEvent = require("field/combat/HitEvent");
local Teams = require("field/combat/Teams");
local System = require("ecs/System");
local AllComponents = require("ecs/query/AllComponents");
local Actor = require("mapscene/behavior/Actor");
local InputListener = require("mapscene/behavior/InputListener");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Locomotion = require("mapscene/physics/Locomotion");

local CombatSystem = Class("CombatSystem", System);

CombatSystem.init = function(self, ecs)
	CombatSystem.super.init(self, ecs);
	self._scriptRunnerQuery = AllComponents:new({ ScriptRunner });
	self._locomotionQuery = AllComponents:new({ CombatData, Locomotion });
	self._inputQuery = AllComponents:new({ CombatData, InputListener });
	self:getECS():addQuery(self._scriptRunnerQuery);
	self:getECS():addQuery(self._locomotionQuery);
	self:getECS():addQuery(self._inputQuery);
end

CombatSystem.beforeScripts = function(self, dt)
	local entities = self._locomotionQuery:getEntities();
	for entity in pairs(entities) do
		local actor = entity:getComponent(Actor);
		if not actor or actor:isIdle() then
			local locomotion = entity:getComponent(Locomotion);
			local combatData = entity:getComponent(CombatData);
			local speed = combatData:getMovementSpeed();
			locomotion:setSpeed(speed);
		end
	end
end

CombatSystem.duringScripts = function(self, dt)
	local hitEvents = self:getECS():getEvents(HitEvent);
	for _, hitEvent in ipairs(hitEvents) do
		local attacker = hitEvent:getEntity();
		local victim = hitEvent:getTargetEntity();
		if Teams:areEnemies(attacker:getTeam(), victim:getTeam()) then
			local damageIntent = attacker:getComponent(DamageIntent);
			local attackerCombatData = attacker:getComponent(CombatData);
			local victimCombatData = victim:getComponent(CombatData);
			if damageIntent and attackerCombatData and victimCombatData then
				attackerCombatData:inflictDamage(damageIntent, victimCombatData);
			end
		end
	end

	local damageEvents = self:getECS():getEvents(DamageEvent);
	for _, damageEvent in ipairs(damageEvents) do
		local victim = damageEvent:getEntity();
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

	local deathEvents = self:getECS():getEvents(DeathEvent);
	for _, deathEvent in ipairs(deathEvents) do
		local victim = deathEvent:getEntity();
		if self._scriptRunnerQuery:contains(victim) then
			local scriptRunner = victim:getComponent(ScriptRunner);
			scriptRunner:signalAllScripts("died");
		end
		if self._inputQuery:contains(victim) then
			local inputListener = victim:getComponent(InputListener);
			inputListener:disable();
		end
	end
end

return CombatSystem;
