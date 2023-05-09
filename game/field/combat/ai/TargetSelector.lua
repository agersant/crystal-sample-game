local CombatData = require("field/combat/CombatData");
local Teams = require("field/combat/Teams");

local TargetSelector = Class("TargetSelector", crystal.Component);

local getAllPossibleTargets = function(self)
	local ecs = self:entity():ecs();
	return ecs:entities_with(CombatData);
end

local passesFilters = function(self, filters, target)
	for _, filter in ipairs(filters) do
		if not filter(self, target) then
			return false;
		end
	end
	return true;
end

local getAll = function(self, filters)
	local out = {};
	for target in pairs(getAllPossibleTargets(self)) do
		if passesFilters(self, filters, target) then
			table.push(out, target);
		end
	end
	return out;
end

local getFittest = function(self, filters, rank)
	local bestScore = nil;
	local bestTarget = nil;
	for target in pairs(getAllPossibleTargets(self)) do
		if passesFilters(self, filters, target) then
			local score = rank(self, target);
			if not bestScore or score > bestScore then
				bestScore = score;
				bestTarget = target;
			end
		end
	end
	return bestTarget;
end

local isAllyOf = function(self, target)
	return Teams:areAllies(self:entity():getTeam(), target:getTeam());
end

local isEnemyOf = function(self, target)
	return Teams:areEnemies(self:entity():getTeam(), target:getTeam());
end

local isNotSelf = function(self, target)
	return self:entity() ~= target;
end

local rankByDistance = function(self, target)
	local body = self:entity():component(crystal.Body);
	if not body then
		return -math.huge;
	end
	return -body:distance_squared_to_entity(target);
end

local isAlive = function(self, target)
	local combatData = target:component(CombatData);
	if not combatData then
		return false;
	end
	return not combatData:isDead();
end

TargetSelector.getAllies = function(self)
	return getAll(self, { isAlive, isAllyOf, isNotSelf });
end

TargetSelector.getEnemies = function(self)
	return getAll(self, { isAlive, isEnemyOf, isNotSelf });
end

TargetSelector.getNearestEnemy = function(self)
	return getFittest(self, { isAlive, isEnemyOf, isNotSelf }, rankByDistance);
end

TargetSelector.getNearestAlly = function(self)
	return getFittest(self, { isAlive, isAllyOf, isNotSelf }, rankByDistance);
end

--#region Tests

crystal.test.add("Get Nearest Enemy", function()
	local world = require("field/Field"):new("assets/map/empty_map.lua");

	local me = world:spawn(crystal.Entity);
	local friend = world:spawn(crystal.Entity);
	local enemyA = world:spawn(crystal.Entity);
	local enemyB = world:spawn(crystal.Entity);
	for _, entity in ipairs({ me, friend, enemyA, enemyB }) do
		entity:add_component(crystal.Body);
		entity:add_component(CombatData);
		entity:add_component(TargetSelector);
	end

	me:setTeam(Teams.party);
	friend:setTeam(Teams.party);
	enemyA:setTeam(Teams.wild);
	enemyB:setTeam(Teams.wild);

	me:set_position(10, 10);
	friend:set_position(8, 8);
	enemyA:set_position(100, 100);
	enemyB:set_position(15, 5);

	world:update(0);
	local nearest = me:getNearestEnemy();
	assert(nearest == enemyB);
end);

crystal.test.add("Get Nearest Ally", function()
	local world = require("field/Field"):new("assets/map/empty_map.lua");

	local me = world:spawn(crystal.Entity);
	local friendA = world:spawn(crystal.Entity);
	local friendB = world:spawn(crystal.Entity);
	local enemy = world:spawn(crystal.Entity);
	for _, entity in ipairs({ me, friendA, friendB, enemy }) do
		entity:add_component(crystal.Body);
		entity:add_component(CombatData);
		entity:add_component(TargetSelector);
	end

	me:setTeam(Teams.wild);
	friendA:setTeam(Teams.wild);
	friendB:setTeam(Teams.wild);
	enemy:setTeam(Teams.party);

	me:set_position(10, 10);
	friendA:set_position(100, 100);
	friendB:set_position(8, 8);
	enemy:set_position(15, 5);

	world:update(0);
	local nearest = me:getNearestAlly();
	assert(nearest == friendB);

	friendB:kill();
	local nearest = me:getNearestAlly();
	assert(nearest == friendA);
end);

--#endregion

return TargetSelector;
