local CombatData = require("field/combat/CombatData");
local Teams = require("field/combat/Teams");
local Component = require("ecs/Component");
local PhysicsBody = require("mapscene/physics/PhysicsBody");

local TargetSelector = Class("TargetSelector", Component);

TargetSelector.init = function(self)
	TargetSelector.super.init(self);
end

local getAllPossibleTargets = function(self)
	local ecs = self:getEntity():getECS();
	return ecs:getAllEntitiesWith(CombatData);
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
			table.insert(out, target);
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
	return Teams:areAllies(self:getEntity():getTeam(), target:getTeam());
end

local isEnemyOf = function(self, target)
	return Teams:areEnemies(self:getEntity():getTeam(), target:getTeam());
end

local isNotSelf = function(self, target)
	return self:getEntity() ~= target;
end

local rankByDistance = function(self, target)
	local physicsBody = self:getEntity():getComponent(PhysicsBody);
	if not physicsBody then
		return -math.huge;
	end
	return -physicsBody:distance2ToEntity(target);
end

local isAlive = function(self, target)
	local combatData = target:getComponent(CombatData);
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

-- TODO these tests should not use a map from engine test-data

local Entity = require("ecs/Entity");
local MapScene = require("mapscene/MapScene");

crystal.test.add("Get Nearest Enemy", { gfx = "mock" }, function()
	local scene = MapScene:new("test-data/empty_map.lua");

	local me = scene:spawn(Entity);
	local friend = scene:spawn(Entity);
	local enemyA = scene:spawn(Entity);
	local enemyB = scene:spawn(Entity);
	for _, entity in ipairs({ me, friend, enemyA, enemyB }) do
		entity:addComponent(PhysicsBody:new(scene:getPhysicsWorld()));
		entity:addComponent(CombatData:new());
		entity:addComponent(TargetSelector:new());
	end

	me:setTeam(Teams.party);
	friend:setTeam(Teams.party);
	enemyA:setTeam(Teams.wild);
	enemyB:setTeam(Teams.wild);

	me:setPosition(10, 10);
	friend:setPosition(8, 8);
	enemyA:setPosition(100, 100);
	enemyB:setPosition(15, 5);

	scene:update(0);
	local nearest = me:getNearestEnemy();
	assert(nearest == enemyB);
end);

crystal.test.add("Get Nearest Ally", { gfx = "mock" }, function()
	local scene = MapScene:new("test-data/empty_map.lua");

	local me = scene:spawn(Entity);
	local friendA = scene:spawn(Entity);
	local friendB = scene:spawn(Entity);
	local enemy = scene:spawn(Entity);
	for _, entity in ipairs({ me, friendA, friendB, enemy }) do
		entity:addComponent(PhysicsBody:new(scene:getPhysicsWorld()));
		entity:addComponent(CombatData:new());
		entity:addComponent(TargetSelector:new());
	end

	me:setTeam(Teams.wild);
	friendA:setTeam(Teams.wild);
	friendB:setTeam(Teams.wild);
	enemy:setTeam(Teams.party);

	me:setPosition(10, 10);
	friendA:setPosition(100, 100);
	friendB:setPosition(8, 8);
	enemy:setPosition(15, 5);

	scene:update(0);
	local nearest = me:getNearestAlly();
	assert(nearest == friendB);

	friendB:kill();
	local nearest = me:getNearestAlly();
	assert(nearest == friendA);
end);

--#endregion

return TargetSelector;
