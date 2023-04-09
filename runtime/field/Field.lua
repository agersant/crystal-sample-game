local AnimationSelectionSystem = require("field/animation/AnimationSelectionSystem");
local CombatSystem = require("field/combat/CombatSystem");
local GameOverSystem = require("field/combat/GameOverSystem");
local InteractionControls = require("field/controls/InteractionControls");
local MovementControls = require("field/controls/MovementControls");
local MovementControlsSystem = require("field/controls/MovementControlsSystem");
local Teams = require("field/combat/Teams");
local DamageNumbersSystem = require("field/hud/damage/DamageNumbersSystem");
local HUDSystem = require("field/hud/HUDSystem");
local PlayerCamera = require("field/player_camera");
local MapScene = require("mapscene/MapScene");

local Field = Class("Field", MapScene);

local PartyMember = Class("PartyMember", crystal.Component);

local spawnParty = function(self, x, y, startAngle)
	local entity = self:spawn("Warrior", {});
	entity:add_component("PartyMember");
	entity:add_component(crystal.InputListener, 1);
	entity:add_component(MovementControls);
	entity:add_component(InteractionControls);
	entity:setTeam(Teams.party);
	entity:set_position(x, y);
	entity:set_rotation(startAngle);

	self:camera_controller():cut_to(PlayerCamera:new(entity));
end

Field.init = function(self, mapName, startX, startY, startAngle)
	Field.super.init(self, mapName);
	local map = self._map;
	local mapWidth, mapHeight = map:pixel_size();
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
	ecs:add_system(HUDSystem);
	ecs:add_context("hud", ecs:system(HUDSystem):getHUD());
end

return Field;
