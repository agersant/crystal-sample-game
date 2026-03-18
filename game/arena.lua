local Arena = Class("Arena", crystal.Scene);

local level_1 = function(self)
    while true do
        self:wait(1);
        self:spawn("Fish");
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

return Arena;
