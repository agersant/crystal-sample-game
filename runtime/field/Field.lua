local AnimationSelectionSystem = require("field/animation/AnimationSelectionSystem");
local CombatSystem = require("field/combat/CombatSystem");
local GameOverSystem = require("field/combat/GameOverSystem");
local InteractionControls = require("field/controls/InteractionControls");
local MovementControls = require("field/controls/MovementControls");
local MovementControlsSystem = require("field/controls/MovementControlsSystem");
local Teams = require("field/combat/Teams");
local DamageNumbersSystem = require("field/hud/damage/DamageNumbersSystem");
local HUDSystem = require("field/hud/HUDSystem");
local PartyMember = require("persistence/party/PartyMember");
local MapScene = require("mapscene/MapScene");
local InputListener = require("mapscene/behavior/InputListener");

local Field = Class("Field", MapScene);

local spawnParty = function(self, x, y, startAngle)
	local partyData = PERSISTENCE:getSaveData():getParty();
	assert(partyData);
	for i, partyMemberData in ipairs(partyData:getMembers()) do
		local assignedPlayerIndex = partyMemberData:getAssignedPlayer();
		local className = partyMemberData:getInstanceClass();
		local class = Class:getByName(className);
		assert(class);

		local entity = self:spawn(class, {});
		entity:addComponent(PartyMember:new());
		if assignedPlayerIndex then
			entity:addComponent(InputListener:new(INPUT:getDevice(assignedPlayerIndex)));
			entity:addComponent(MovementControls:new());
			entity:addComponent(InteractionControls:new());
		end
		entity:setTeam(Teams.party);
		entity:setPosition(x, y);
		entity:setAngle(startAngle);
	end
end

Field.init = function(self, mapName, startX, startY, startAngle)
	Field.super.init(self, mapName);

	local map = self:getMap();
	local mapWidth = map:getWidthInPixels();
	local mapHeight = map:getHeightInPixels();
	startX = startX or mapWidth / 2;
	startY = startY or mapHeight / 2;
	startAngle = startAngle or 0;
	spawnParty(self, startX, startY, startAngle);
end

Field.addSystems = function(self)
	Field.super.addSystems(self);
	local ecs = self:getECS();
	ecs:addSystem(AnimationSelectionSystem:new(ecs));
	ecs:addSystem(MovementControlsSystem:new(ecs));
	ecs:addSystem(CombatSystem:new(ecs));
	ecs:addSystem(DamageNumbersSystem:new(ecs));
	ecs:addSystem(GameOverSystem:new(ecs));
	ecs:addSystem(HUDSystem:new(ecs, self._renderer:getViewport()));
end

Field.getHUD = function(self)
	return self._ecs:getSystem(HUDSystem):getHUD();
end

return Field;
