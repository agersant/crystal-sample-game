local Arena = Class("Arena", crystal.Scene);

local pattern_baby = function(self)
    self:spawn_fish("W", 3);
    self:wait(3);
    self:spawn_fish("N", 3);
    self:wait(2);
    self:spawn_fish("W", 2);
    self:spawn_fish("E", 4);
    self:wait(1.5);
    self:spawn_fish("N", 1, 3, 5);
end

local pattern_ones_and_threes = function(self)
    self:spawn_fish("N", 3);
    self:spawn_fish("W", 3);
    self:spawn_fish("E", 5);
    self:wait(0.4);
    self:spawn_fish("W", 1);
    self:wait(0.4);
    self:spawn_fish("E", 4);
    self:wait(0.4);
    self:spawn_fish("N", 1, 2, 5);
    self:wait(0.8);
    self:spawn_fish("E", 3);
    self:wait(0.4);
    self:spawn_fish("W", 2);
    self:wait(0.4);
    self:spawn_fish("E", 5);
    self:spawn_fish("N", 2, 3);
    self:wait(0.8);
    self:spawn_fish("N", 1, 5);
end

local pattern_stagger_duos = function(self)
     self:spawn_fish("E", 3);
    self:spawn_fish("W", 1, 2);
    self:wait(1);
    self:spawn_fish("N", 1, 5);
    self:wait(0.5);
    self:spawn_fish("W", 4, 5);
    self:wait(1.5);
    self:spawn_fish("E", 1, 4);
    self:spawn_fish("W", 2, 5);
    self:wait(0.5);
    self:spawn_fish("N", 2, 3);
    self:wait(0.5);
    self:spawn_fish("W", 1, 4);
    self:spawn_fish("N", 5);
    self:wait(0.5);
    self:spawn_fish("E", 3, 4);
end

local pattern_full_rotate = function(self)
     for i = 1,5 do
        if i ~= 2 then
            self:spawn_fish("W", 6 - i);
        end
        self:wait(0.2);
    end
    for i = 1,5 do
        if i ~= 4 then
            self:spawn_fish("N", i);
        end
        self:wait(0.2);
    end
    for i = 1,5 do
        if i ~= 2 then
            self:spawn_fish("E", i);
        end
        self:wait(0.2);
    end
end

local level_1 = function(self)
    while true do
        self:wait(2);
        pattern_baby(self);
        self:wait(2.5);
        pattern_stagger_duos(self);
        self:wait(2.5);
        pattern_full_rotate(self);
        self:wait(2.5);
        pattern_ones_and_threes(self);
        self:wait(2.5);
    end
end

Arena.init = function(self)
    self.camera_controller = crystal.CameraController:new();
    self.camera_controller:cut_to(crystal.Camera:new());

    self.ecs = crystal.ECS:new();
    self:add_alias(self.ecs);

    self.physics_system = self.ecs:add_system(crystal.PhysicsSystem);
    self.script_system = self.ecs:add_system(crystal.ScriptSystem);
    self.movement_controls_system = self.ecs:add_system("MovementControlsSystem");
    self.draw_system = self.ecs:add_system(crystal.DrawSystem);

    self.player = self.ecs:spawn("Player");
    self.platform = self.ecs:spawn("Platform");

    self.level_script = crystal.Script:new(level_1);
    self.level_script:add_alias(self);
end

Arena.update = function(self, dt)
    self.ecs:update();
    self.physics_system:simulate_physics(dt);
    self.movement_controls_system:apply_movement_controls(dt);
    self.camera_controller:update(dt);
    self.level_script:update(dt);
    self.script_system:run_scripts(dt);
    self.draw_system:update_drawables(dt);
end

Arena.draw = function(self)
    love.graphics.clear(10/255, 152/255, 172/255);
    self.camera_controller:draw(function()
        self.draw_system:draw_entities();
    end);

    love.graphics.push();
	love.graphics.translate(self.camera_controller:offset());
	self.ecs:notify_systems("draw_debug");
	love.graphics.pop();
end

Arena.spawn_fish = function(self, origin, ...)
    local lanes = {...};
    for _, lane in ipairs(lanes) do
        self:spawn("Fish", origin, lane);    
    end
end

return Arena;
