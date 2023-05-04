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

local Field = Class("Field", crystal.Scene);

local PartyMember = Class("PartyMember", crystal.Component);

local spawnParty = function(self, x, y, start_rotation)
	local entity = self.ecs:spawn("Warrior", {});
	entity:add_component("PartyMember");
	entity:add_component(crystal.InputListener, 1);
	entity:add_component(MovementControls);
	entity:add_component(InteractionControls);
	entity:setTeam(Teams.party);
	entity:set_position(x, y);
	entity:set_rotation(start_rotation);

	self.camera_controller:cut_to(PlayerCamera:new(entity));
end

Field.init = function(self, map_name, start_x, start_y, start_rotation)
	crystal.log.info("Instancing scene for map: " .. tostring(map_name));

	self.ecs = crystal.ECS:new();

	self.camera_controller = crystal.CameraController:new();
	self.ecs:add_context("camera_controller", self.camera_controller);

	self.map = crystal.assets.get(map_name);
	self.ecs:add_context("map", self.map);

	self.ai_system = self.ecs:add_system(crystal.AISystem, self.map);
	self.draw_system = self.ecs:add_system(crystal.DrawSystem);
	self.input_system = self.ecs:add_system(crystal.InputSystem);
	self.physics_system = self.ecs:add_system(crystal.PhysicsSystem);
	self.script_system = self.ecs:add_system(crystal.ScriptSystem);

	self.animation_selection_system = self.ecs:add_system(AnimationSelectionSystem);
	self.movement_controls_sytem = self.ecs:add_system(MovementControlsSystem);
	self.combat_system = self.ecs:add_system(CombatSystem);
	self.damage_number_system = self.ecs:add_system(DamageNumbersSystem);
	self.game_over_system = self.ecs:add_system(GameOverSystem);
	self.hud_system = self.ecs:add_system(HUDSystem);
	self.ecs:add_context("hud", self.ecs:system(HUDSystem):getHUD());

	self.map:spawn_entities(self.ecs);

	local map_width, map_height = self.map:pixel_size();
	start_x = start_x or map_width / 2;
	start_y = start_y or map_height / 2;
	start_rotation = start_rotation or 0;
	spawnParty(self, start_x, start_y, start_rotation);
end

Field.update = function(self, dt)
	self.ecs:update();
	self.physics_system:simulate_physics(dt);
	self.movement_controls_sytem:apply_movement_controls();
	self.combat_system:apply_movement_speed();
	self.camera_controller:update(dt);
	self.script_system:run_scripts(dt);
	local player_index = 1;
	for _, input in ipairs(crystal.input.player(player_index):events()) do
		if not self.hud_system:handle_input(player_index, input) then
			self.input_system:handle_input(player_index, input);
		end
	end
	self.ai_system:update_ai(dt);
	self.animation_selection_system:select_animations();
	self.combat_system:run_combat_logic(dt);
	self.damage_number_system:update();
	self.game_over_system:update();
	self.hud_system:update(dt);
	self.draw_system:update_drawables(dt);
end

Field.draw = function(self)
	crystal.window.draw_native(function()
		self.camera_controller:draw(function()
			self.draw_system:draw_entities();
		end);
	end);

	love.graphics.push();
	love.graphics.translate(self.camera_controller:offset());
	self.ecs:notify_systems("draw_debug");
	love.graphics.pop();

	crystal.window.draw_native(function()
		self.hud_system:draw_ui();
	end);
end

Field.spawn = function(self, class, ...)
	return self.ecs:spawn(class, ...);
end

---@param class string
Field.spawn_near_player = function(self, class)
	local player_body;
	local players = self.ecs:entities_with(crystal.InputListener);
	for entity in pairs(players) do
		player_body = entity:component(crystal.Body);
		break;
	end

	assert(class);
	local entity = self.ecs:spawn(class);

	local body = entity:component(crystal.Body);
	if body and player_body then
		local x, y = player_body:position();
		local rotation = 2 * math.pi * math.random();
		local radius = 40;
		x = x + radius * math.cos(rotation);
		y = y + radius * math.sin(rotation);
		x, y = self.map:nearest_navigable_point(x, y);
		if x and y then
			body:set_position(x, y);
		end
	end
end

crystal.cmd.add("loadMap mapName:string", function(map_name)
	local map_path = string.merge_paths("assets/map", map_name .. ".lua");
	local new_scene = Field:new(map_path);
	crystal.scene.replace(new_scene);
end);

crystal.cmd.add("spawn className:string", function(class_name)
	local scene = crystal.scene.current();
	if scene then
		scene:spawn_near_player(class_name);
	end
end);

--#region Tests

crystal.test.add("Can spawn entities", function()
	local scene = Field:new("test-data/empty.lua");
	local Piggy = Class:test("Piggy", crystal.Entity);
	local piggy = scene.ecs:spawn(Piggy);
	scene:update(0);
	assert(scene.ecs:entities()[piggy]);
end);

crystal.test.add("Can use the `spawn` command", function()
	local TestSpawnCommand = Class("TestSpawnCommand", crystal.Entity);

	local scene = Field:new("test-data/empty.lua");

	scene:spawn_near_player(TestSpawnCommand);
	scene:update(0);

	for entity in pairs(scene.ecs:entities()) do
		if entity:inherits_from(TestSpawnCommand) then
			return;
		end
	end
	error("Spawned entity not found");
end);

--#endregion

return Field;
