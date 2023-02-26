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

local Field = Class("Field", MapScene);

local spawnParty = function(self, x, y, startAngle)
	local partyData = PERSISTENCE:getSaveData():getParty();
	assert(partyData);
	for i, partyMemberData in ipairs(partyData:getMembers()) do
		local assignedPlayerIndex = partyMemberData:getAssignedPlayer();
		local className = partyMemberData:getInstanceClass();
		local class = Class:get_by_name(className);
		assert(class);

		local entity = self:spawn(class, {});
		entity:add_component(PartyMember);
		if assignedPlayerIndex then
			entity:add_component(crystal.InputListener, assignedPlayerIndex);
			entity:add_component(MovementControls);
			entity:add_component(InteractionControls);
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

Field.add_systems = function(self)
	Field.super.add_systems(self);
	local ecs = self:ecs();
	ecs:add_system(AnimationSelectionSystem);
	ecs:add_system(MovementControlsSystem);
	ecs:add_system(CombatSystem);
	ecs:add_system(DamageNumbersSystem);
	ecs:add_system(GameOverSystem);
	ecs:add_system(HUDSystem, self._renderer:getViewport());
end

Field.getHUD = function(self)
	return self._ecs:system(HUDSystem):getHUD();
end

return Field;
