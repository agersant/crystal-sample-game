local Stat = require("field/combat/stats/Stat");
local Stats = require("field/combat/stats/Stats");
local Damage = require("field/combat/damage/Damage");
local DamageEvent = require("field/combat/damage/DamageEvent");
local DeathEvent = require("field/combat/damage/DeathEvent");
local DamageIntent = require("field/combat/damage/DamageIntent");
local DamageTypes = require("field/combat/damage/DamageTypes");
local Elements = require("field/combat/damage/Elements");
local ScalingSources = require("field/combat/stats/ScalingSources");
local Teams = require("field/combat/Teams");

local CombatData = Class("CombatData", crystal.Component);

local computeScalingSourceAmount, computeScalingSourceAmountInternal;

local evaluateStatInternal = function(self, statObject, guards)
	assert(statObject);
	assert(statObject:inherits_from(Stat));

	local stat = self._statsReverseLookups[statObject];
	assert(stat);

	local guards = guards or {};
	local newGuards = table.copy(guards);
	newGuards[stat] = true;

	for modifier in pairs(self._statModifiers[stat]) do
		local scalingRatio = modifier:getScalingRatio();
		if scalingRatio ~= 0 then
			local scalingSource = modifier:getScalingSource();
			newGuards[scalingSource] = true;
		end
	end

	local value = statObject:getBaseValue();
	for modifier in pairs(self._statModifiers[stat]) do
		value = value + modifier:getFlatAmount();
		local scalingSource = modifier:getScalingSource();
		if not guards[scalingSource] then
			local scalingRatio = modifier:getScalingRatio();
			if scalingRatio ~= 0 then
				local scalingSourceValue = computeScalingSourceAmountInternal(self, scalingSource, newGuards);
				value = value + scalingRatio * scalingSourceValue;
			end
		end
	end

	return value;
end

computeScalingSourceAmountInternal = function(self, scalingSource, guards)
	if self._stats[scalingSource] then
		return evaluateStatInternal(self, self:getStat(scalingSource), guards);
	elseif scalingSource == ScalingSources.MISSING_HEALTH then
		local max = evaluateStatInternal(self, self:getStat(Stats.MAX_HEALTH), guards);
		local current = evaluateStatInternal(self, self:getStat(Stats.HEALTH), guards);
		return max - current;
	else
		error("Unexpected scaling source");
	end
end

computeScalingSourceAmount = function(self, scalingSource)
	return computeScalingSourceAmountInternal(self, scalingSource, {});
end

local mitigateDamage = function(self, damage)
	local effectiveDamage = Damage:new();
	for _, damageType in pairs(DamageTypes) do
		for _, element in pairs(Elements) do
			local rawAmount = damage:getAmount(damageType, element);
			local mitigatedAmount = rawAmount;

			-- Apply defense stat
			local defense = self._defenses[damageType];
			assert(defense);
			local defenseValue = evaluateStatInternal(self, defense);
			local mitigationFactor = defenseValue / (defenseValue + 100);
			mitigatedAmount = mitigatedAmount * (1 - mitigationFactor);

			-- Apply elemental resistance
			local resistance = self._resistances[element];
			assert(resistance);
			mitigatedAmount = mitigatedAmount * (1 - evaluateStatInternal(self, resistance));

			effectiveDamage:addAmount(mitigatedAmount, damageType, element);
		end
	end
	return effectiveDamage;
end

local computeDamage = function(self, intent, target)
	local damage = Damage:new();
	for unit in pairs(intent:getDamageUnits()) do
		local damageType = unit:getDamageType();
		local element = unit:getElement();
		local scalingRatio = unit:getScalingRatio();
		local amount = unit:getFlatAmount();

		-- Apply scaling
		if scalingRatio ~= 0 then
			local damageScalingSource = unit:getDamageScalingSource();
			local scalingSource = damageScalingSource:getScalingSource();
			local scalingSourceAmount;
			if damageScalingSource:isScalingOffTarget() then
				scalingSourceAmount = computeScalingSourceAmount(target, scalingSource);
			else
				scalingSourceAmount = computeScalingSourceAmount(self, scalingSource);
			end
			if scalingSourceAmount ~= 0 then
				amount = amount + scalingRatio * scalingSourceAmount;
			end
		end

		-- Apply affinity
		local affinity = self._affinities[element];
		assert(affinity);
		amount = amount * (1 + evaluateStatInternal(self, affinity));
		damage:addAmount(amount, damageType, element);
	end
	return damage;
end

local addStat = function(self, stat, statObject)
	assert(not self._stats[stat]);
	self._stats[stat] = statObject;
	self._statsReverseLookups[statObject] = stat;
	return statObject;
end

CombatData.init = function(self)
	self:setTeam(Teams.wild);

	self._stats = {};
	self._statsReverseLookups = {};

	addStat(self, Stats.MOVEMENT_SPEED, Stat:new(100, 1, nil));
	addStat(self, Stats.HEALTH, Stat:new(100, 0, nil));
	addStat(self, Stats.MAX_HEALTH, Stat:new(100, 1, nil));

	self._offenses = {};
	self._defenses = {};
	for name, damageType in pairs(DamageTypes) do
		self._offenses[damageType] = addStat(self, Stats["OFFENSE_" .. name], Stat:new(0, 0, nil));
		self._defenses[damageType] = addStat(self, Stats["DEFENSE_" .. name], Stat:new(0, 0, nil));
	end

	self._affinities = {};
	self._resistances = {};
	for name, element in pairs(Elements) do
		self._affinities[element] = addStat(self, Stats["AFFINITY_" .. name], Stat:new(0, 0, nil));
		self._resistances[element] = addStat(self, Stats["RESISTANCE_" .. name], Stat:new(0, 0, nil));
	end

	self._buffs = {};
	self._onHitEffects = {};
	self._statModifiers = {};

	for stat, statObject in pairs(self._stats) do
		self._statModifiers[stat] = {};
	end
end

CombatData.setTeam = function(self, team)
	assert(Teams:is_valid(team));
	self._team = team;
end

CombatData.getTeam = function(self)
	return self._team;
end

CombatData.inflictDamage = function(self, intent, target)
	assert(intent);
	assert(target);
	assert(target:inherits_from(CombatData));
	assert(intent:inherits_from(DamageIntent));
	local damage = computeDamage(self, intent, target);
	local onHitEffects = {};
	for _, onHitEffect in ipairs(intent:getOnHitEffects()) do
		table.push(onHitEffects, onHitEffect);
	end
	for onHitEffect in pairs(self._onHitEffects) do
		table.push(onHitEffects, onHitEffect);
	end
	target:receiveDamage(self, damage, onHitEffects);
end

CombatData.receiveDamage = function(self, attacker, damage, onHitEffects)
	assert(attacker);
	assert(damage);
	assert(onHitEffects);
	if self:isDead() then
		return;
	end
	local effectiveDamage = mitigateDamage(self, damage);
	local health = self:getStat(Stats.HEALTH);
	health:substract(effectiveDamage:getTotal());
	self:entity():create_event(DamageEvent, attacker, effectiveDamage, onHitEffects);
	if self:isDead() then
		self:entity():create_event(DeathEvent);
	end
	return effectiveDamage;
end

CombatData.addBuff = function(self, buff)
	self._buffs[buff] = true;
	buff:install(self);
end

CombatData.removeBuff = function(self, buff)
	assert(self._buffs[buff]);
	self._buffs[buff] = nil;
	buff:uninstall(self);
end

CombatData.addOnHitEffect = function(self, onHitEffect)
	self._onHitEffects[onHitEffect] = true;
end

CombatData.removeOnHitEffect = function(self, onHitEffect)
	assert(self._onHitEffects[onHitEffect]);
	self._onHitEffects[onHitEffect] = nil;
end

CombatData.addStatModifier = function(self, statModifier)
	self._statModifiers[statModifier:getStat()][statModifier] = true;
end

CombatData.removeStatModifier = function(self, statModifier)
	self._statModifiers[statModifier:getStat()][statModifier] = nil;
end

CombatData.getStat = function(self, stat)
	local outputStat = self._stats[stat];
	assert(outputStat)
	return outputStat;
end

CombatData.evaluateStat = function(self, stat)
	assert(stat);
	assert(type(stat) == "number");
	return evaluateStatInternal(self, self:getStat(stat), {});
end

CombatData.getCurrentHealth = function(self)
	return self:evaluateStat(Stats.HEALTH);
end

CombatData.getMovementSpeed = function(self)
	return self:evaluateStat(Stats.MOVEMENT_SPEED);
end

CombatData.kill = function(self)
	self:getStat(Stats.HEALTH):setBaseValue(0);
end

CombatData.isDead = function(self)
	return self:getCurrentHealth() <= 0;
end

--#region Tests

local DamageScalingSource = require("field/combat/damage/DamageScalingSource");
local DamageUnit = require("field/combat/damage/DamageUnit");
local StatModifier = require("field/combat/stats/StatModifier");

crystal.test.add("Kill", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	assert(not entity:isDead());
	entity:kill();
	assert(entity:isDead());
end);

crystal.test.add("Inflict flat damage", function()
	local ecs = crystal.ECS:new();
	local attacker = ecs:spawn(crystal.Entity);
	local victim = ecs:spawn(crystal.Entity);
	attacker:add_component(CombatData);
	victim:add_component(CombatData);
	ecs:update(0);

	local intent = DamageIntent:new();
	intent:setDamagePayload({ DamageUnit:new(10) });

	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 90);
end);

crystal.test.add("Inflict scaling physical damage", function()
	local ecs = crystal.ECS:new();
	local attacker = ecs:spawn(crystal.Entity);
	local victim = ecs:spawn(crystal.Entity);
	attacker:add_component(CombatData);
	victim:add_component(CombatData);
	ecs:update(0);

	local intent = DamageIntent:new();
	local unit = DamageUnit:new();
	unit:setScalingAmount(2, DamageScalingSource:new(ScalingSources.OFFENSE_PHYSICAL));
	intent:setDamagePayload({ unit });

	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 100);

	attacker:getStat(Stats.OFFENSE_PHYSICAL):setBaseValue(3);
	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 94);
end);

crystal.test.add("Mitigate physical damage", function()
	local ecs = crystal.ECS:new();
	local attacker = ecs:spawn(crystal.Entity);
	local victim = ecs:spawn(crystal.Entity);
	attacker:add_component(CombatData);
	victim:add_component(CombatData);
	ecs:update(0);

	local intent = DamageIntent:new();
	victim:getStat(Stats.DEFENSE_PHYSICAL):setBaseValue(100);

	intent:setDamagePayload({ DamageUnit:new(100) });
	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 50);

	intent:setDamagePayload({ DamageUnit:new(50) });
	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 25);
end);

crystal.test.add("Elemental affinity multiplies damage", function()
	local ecs = crystal.ECS:new();
	local attacker = ecs:spawn(crystal.Entity);
	local victim = ecs:spawn(crystal.Entity);
	attacker:add_component(CombatData);
	victim:add_component(CombatData);
	ecs:update(0);

	local intent = DamageIntent:new();
	intent:setDamagePayload({ DamageUnit:new(10, DamageTypes.MAGIC, Elements.FIRE) });

	attacker:getStat(Stats.AFFINITY_FIRE):setBaseValue(0.5);
	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 85);
end);

crystal.test.add("Elemental resistance multiplies damage", function()
	local ecs = crystal.ECS:new();
	local attacker = ecs:spawn(crystal.Entity);
	local victim = ecs:spawn(crystal.Entity);
	attacker:add_component(CombatData);
	victim:add_component(CombatData);
	ecs:update(0);

	local intent = DamageIntent:new();
	intent:setDamagePayload({ DamageUnit:new(10, DamageTypes.MAGIC, Elements.FIRE) });

	victim:getStat(Stats.RESISTANCE_FIRE):setBaseValue(0.5);
	attacker:inflictDamage(intent, victim:component(CombatData));
	assert(victim:getCurrentHealth() == 95);
end);

crystal.test.add("Flat stat modifiers", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	ecs:update(0);

	entity:addStatModifier(StatModifier:new(Stats.OFFENSE_MAGIC, 20));
	local offenseMagic = entity:getStat(Stats.OFFENSE_MAGIC);
	assert(offenseMagic:getBaseValue() == 0);
	assert(entity:evaluateStat(Stats.OFFENSE_MAGIC) == 20);
end);

crystal.test.add("Flat + same-stat percentage modifier", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	ecs:update(0);

	local modifier = StatModifier:new(Stats.OFFENSE_MAGIC, 20);
	modifier:setScalingAmount(0.10, ScalingSources.OFFENSE_MAGIC);
	entity:addStatModifier(modifier);
	assert(entity:evaluateStat(Stats.OFFENSE_MAGIC) == 22);
end);

crystal.test.add("Convert 10% of offense into defense and vice versa", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	ecs:update(0);

	local offenseModifier = StatModifier:new(Stats.OFFENSE_PHYSICAL, 0);
	offenseModifier:setScalingAmount(0.10, ScalingSources.DEFENSE_PHYSICAL);
	entity:addStatModifier(offenseModifier);

	local defenseModifier = StatModifier:new(Stats.DEFENSE_PHYSICAL, 0);
	defenseModifier:setScalingAmount(0.10, ScalingSources.OFFENSE_PHYSICAL);
	entity:addStatModifier(defenseModifier);

	entity:getStat(Stats.OFFENSE_PHYSICAL):setBaseValue(50);
	entity:getStat(Stats.DEFENSE_PHYSICAL):setBaseValue(100);

	assert(entity:evaluateStat(Stats.OFFENSE_PHYSICAL) == 60);
	assert(entity:evaluateStat(Stats.DEFENSE_PHYSICAL) == 105);
end);

crystal.test.add("Swap offense and defense", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	ecs:update(0);

	local offenseNullify = StatModifier:new(Stats.OFFENSE_PHYSICAL, 0);
	offenseNullify:setScalingAmount(-1, ScalingSources.OFFENSE_PHYSICAL);
	local offenseSwap = StatModifier:new(Stats.OFFENSE_PHYSICAL, 0);
	offenseSwap:setScalingAmount(1, ScalingSources.DEFENSE_PHYSICAL);
	entity:addStatModifier(offenseNullify);
	entity:addStatModifier(offenseSwap);

	local defenseNullify = StatModifier:new(Stats.DEFENSE_PHYSICAL, 0);
	defenseNullify:setScalingAmount(-1, ScalingSources.DEFENSE_PHYSICAL);
	local defenseSwap = StatModifier:new(Stats.DEFENSE_PHYSICAL, 0);
	defenseSwap:setScalingAmount(1, ScalingSources.OFFENSE_PHYSICAL);
	entity:addStatModifier(defenseNullify);
	entity:addStatModifier(defenseSwap);

	entity:getStat(Stats.OFFENSE_PHYSICAL):setBaseValue(50);
	entity:getStat(Stats.DEFENSE_PHYSICAL):setBaseValue(100);

	assert(entity:evaluateStat(Stats.OFFENSE_PHYSICAL) == 100);
	assert(entity:evaluateStat(Stats.DEFENSE_PHYSICAL) == 50);
end);

crystal.test.add("Three way +10% stat modifiers", function()
	local ecs = crystal.ECS:new();
	local entity = ecs:spawn(crystal.Entity);
	entity:add_component(CombatData);
	ecs:update(0);

	local offenseFromDefense = StatModifier:new(Stats.OFFENSE_PHYSICAL, 0);
	offenseFromDefense:setScalingAmount(.1, ScalingSources.DEFENSE_PHYSICAL);
	entity:addStatModifier(offenseFromDefense);

	local defenseFromHealth = StatModifier:new(Stats.DEFENSE_PHYSICAL, 0);
	defenseFromHealth:setScalingAmount(.1, ScalingSources.HEALTH);
	entity:addStatModifier(defenseFromHealth);

	local healthFromOffense = StatModifier:new(Stats.HEALTH, 0);
	healthFromOffense:setScalingAmount(.1, ScalingSources.OFFENSE_PHYSICAL);
	entity:addStatModifier(healthFromOffense);

	entity:getStat(Stats.OFFENSE_PHYSICAL):setBaseValue(100);
	entity:getStat(Stats.DEFENSE_PHYSICAL):setBaseValue(100);
	entity:getStat(Stats.HEALTH):setBaseValue(100);
	assert(entity:evaluateStat(Stats.OFFENSE_PHYSICAL) == 111);
	assert(entity:evaluateStat(Stats.DEFENSE_PHYSICAL) == 111);
	assert(entity:evaluateStat(Stats.HEALTH) == 111);

	entity:getStat(Stats.OFFENSE_PHYSICAL):setBaseValue(50);
	entity:getStat(Stats.DEFENSE_PHYSICAL):setBaseValue(100);
	entity:getStat(Stats.HEALTH):setBaseValue(200);
	assert(entity:evaluateStat(Stats.OFFENSE_PHYSICAL) == 62);
	assert(entity:evaluateStat(Stats.DEFENSE_PHYSICAL) == 120.5);
	assert(entity:evaluateStat(Stats.HEALTH) == 206);
end);

--#endregion

return CombatData;
