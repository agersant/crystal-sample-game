local Arena = Class("Arena", crystal.Scene);

local pattern_baby = function(self)
    self:spawn_default("W", 3);
    self:wait(3);
    self:spawn_default("N", 3);
    self:wait(2);
    self:spawn_default("W", 2);
    self:spawn_default("E", 4);
    self:wait(1.5);
    self:spawn_default("N", 1, 3, 5);
    self:wait(2);
    self:spawn_default("S", 2, 4);
end

local pattern_squares = function(self)
    self:spawn_default("W", 3);
    self:spawn_default("E", 3);
    self:spawn_default("S", 3);
    self:spawn_default("N", 3);
    self:wait(2.2);
    self:spawn_default("W", 2);
    self:spawn_default("E", 4);
    self:spawn_default("S", 2);
    self:spawn_default("N", 4);
    self:wait(2.2);
    self:spawn_default("N", 1);
    self:spawn_default("S", 5);
    self:wait(0.5);
    self:spawn_default("W", 1);
    self:spawn_default("E", 5);
end

local pattern_slow_trick = function(self)
    self:spawn_default("S", 1, 5);
    self:wait(0.4);
    self:spawn_default("N", 3);
    self:wait(2);
    self:spawn_default("S", 2);
    self:spawn_default("N", 4);
    self:wait(1.5);
    self:spawn_default("E", 2, 3);
    self:spawn_default("W", 4);
    self:wait(2);
    self:spawn_default("N", 1, 3);
    self:spawn_default("E", 2, 5);
    self:wait(2);
    
    self:spawn_default("E", 1, 5);
    self:wait(0.4);
    self:spawn_default("W", 3);
    self:wait(2);
    self:spawn_default("E", 2);
    self:spawn_default("W", 4);
    self:wait(1.5);
    self:spawn_default("S", 2, 3);
    self:spawn_default("N", 4);
    self:wait(2);
    self:spawn_default("W", 1, 3);
    self:spawn_default("S", 2, 5);
end

local pattern_blocks = function(self)
    for i = 1, 3 do
        local d = 1.8 - i * 0.3;
        self:spawn_default("E", 1, 2, 3);
        self:wait(d);
        self:spawn_default("N", 1, 2, 3);
        self:wait(d);
        self:spawn_default("W", 3, 4, 5);
        self:wait(d);
        self:spawn_default("S", 3, 4, 5);
        self:wait(d);
    end
end

local pattern_modulo = function(self)
    self:thread(function(self)
        self:wait(5);
        self:spawn_default("S", 3);
        self:wait(3);
        self:spawn_default("N", 4);
    end);
    for i = 1, 10 do
        self:spawn_default("W", 1 + (i*17)%13%5, 1 + (i*11)%12%5);
        self:wait(1);
    end
end

local pattern_ones_and_threes = function(self)
    self:spawn_default("N", 3);
    self:spawn_default("W", 3);
    self:spawn_default("E", 5);
    self:wait(0.4);
    self:spawn_default("W", 1);
    self:wait(0.4);
    self:spawn_default("E", 4);
    self:wait(0.4);
    self:spawn_default("N", 1, 2, 5);
    self:wait(0.8);
    self:spawn_default("E", 3);
    self:wait(0.4);
    self:spawn_default("W", 2);
    self:wait(0.4);
    self:spawn_default("E", 5);
    self:spawn_default("N", 2, 3);
    self:wait(0.8);
    self:spawn_default("N", 1, 5);
end

local pattern_stagger_duos = function(self)
    self:spawn_default("E", 3);
    self:spawn_default("W", 1, 2);
    self:wait(1);
    self:spawn_default("N", 1, 5);
    self:wait(0.5);
    self:spawn_default("W", 4, 5);
    self:wait(1.5);
    self:spawn_default("E", 1, 4);
    self:spawn_default("W", 2, 5);
    self:wait(0.5);
    self:spawn_default("N", 2, 3);
    self:wait(0.5);
    self:spawn_default("W", 1, 4);
    self:spawn_default("N", 5);
    self:wait(0.5);
    self:spawn_default("E", 3, 4);
end

local pattern_zebulon = function(self)
    self:spawn_default("E", 5);
    self:wait(0.8);
    self:spawn_default("W", 4);
    self:wait(0.8);
    self:spawn_default("E", 3);
    self:wait(0.8);
    self:spawn_default("W", 2);
    self:wait(0.8);
    self:spawn_default("E", 1);
    self:wait(0.8);
    self:spawn_default("W", 4);
    self:spawn_default("N", 1);
    self:wait(0.4);
    self:spawn_default("N", 3);
    self:wait(0.4);
    self:spawn_default("N", 5);
    self:wait(0.8);
    self:spawn_default("W", 4, 5);
end

local pattern_full_rotate = function(self)
     for i = 1,5 do
        if i ~= 2 then
            self:spawn_default("W", 6 - i);
        end
        self:wait(0.2);
    end
    for i = 1,5 do
        if i ~= 4 then
            self:spawn_default("N", i);
        end
        self:wait(0.2);
    end
    for i = 1,5 do
        if i ~= 2 then
            self:spawn_default("E", i);
        end
        self:wait(0.2);
    end
end

local pattern_chaos_engine = function(self)
    local a = self:thread(function(self)
        for i = 1, 15 do
            local d = i%2 == 0 and "E" or "N";
            self:spawn_default(d, 1 + (2*i)%5);
            self:wait(0.7);
        end
    end);
    local b = self:thread(function(self)
        for i = 1, 10 do
            local d = i%2 == 0 and "W" or "S";
            self:spawn_default(d, 1 + (3 + (2*i))%5);
            self:wait(0.6);
        end
    end);
    a:block();
    b:block();
end


local pattern_sin = function(self)
    for i = 1, 4 do
        self:spawn_default("S", i);
        self:wait(0.2);
    end
    self:wait(1.4);
    for i = 5, 2, -1 do
        self:spawn_default("S", i);
        self:wait(0.2);
    end
    self:wait(1.4);

    self:spawn_default("S", 1, 3, 5);
    self:wait(0.7);
    self:spawn_default("S", 2);
    self:wait(0.2);
    self:spawn_default("E", 3);
    self:spawn_default("W", 1);
    self:wait(0.2);
    self:spawn_default("S", 4);
    self:wait(1.4);

    for i = 1, 3 do
        self:spawn_default("S", i);
        self:wait(0.1);
    end
    self:wait(0.8);
    for i = 5, 4, -1 do
        self:spawn_default("S", i);
        self:wait(0.1);
    end
    self:wait(0.8);
    self:spawn_default("N", 1, 5);
    self:spawn_default("S", 3);
end

local pattern_coverage = function(self)
    self:spawn_default("E", 1, 2, 5);
    self:spawn_default("W", 3, 4);
    self:wait(2);
    self:spawn_default("N", 1);
    self:spawn_default("S", 5);
    self:wait(0.8);
    self:spawn_default("N", 3, 4);
    self:spawn_default("S", 1, 2);
    self:wait(0.8);
    self:spawn_default("W", 2, 3);
    self:spawn_default("E", 5);
    self:wait(1.5);
    self:spawn_default("N", 2);
    self:spawn_default("W", 2);
    self:spawn_default("S", 4);
    self:spawn_default("E", 4);
end

local pattern_fast_intro = function(self)
    self:spawn_fast("W", 1, 5);
    self:wait(2);
    self:spawn_fast("W", 3);
    self:wait(2);
    self:spawn_fast("W", 2, 4);
    self:wait(3);
    self:spawn_fast("W", 1, 2);
    self:spawn_fast("E", 4, 5);
    self:wait(1.5);
    self:spawn_fast("N", 1, 2);
    self:spawn_fast("S", 4, 5);
end

local pattern_gaps = function(self)
    self:spawn_default("N", 1, 2, 4, 5);
    self:wait(0.3);
    self:spawn_fast("N", 3);
    self:wait(3);
    
    self:spawn_default("N", 2, 3, 4, 5);
    self:wait(0.3);
    self:spawn_fast("N", 1);
    self:wait(3);
    
    self:spawn_default("N", 1, 2, 5);
    self:wait(0.3);
    self:spawn_fast("N", 3, 4);
    self:wait(3);

    self:spawn_default("N", 2, 3);
    self:wait(0.3);
    self:spawn_fast("N", 1, 4, 5);
    self:wait(3);

    self:spawn_default("N", 4);
    self:wait(0.3);
    self:spawn_fast("N", 1, 2, 3, 5);
     self:wait(3);

    self:spawn_default("N", 1);
    self:wait(0.3);
    self:spawn_fast("N", 2, 3, 4, 5);
end

local pattern_bomberman = function(self)
    self:spawn_default("N", 1, 2);
    self:spawn_default("W", 3);
    self:spawn_default("E", 1, 4);
    self:spawn_default("S", 3, 5);
    self:wait(2);
    self:spawn_default("N", 2);
    self:spawn_default("E", 3);
    self:spawn_default("W", 1, 5);
    self:spawn_default("S", 1, 4);
    self:wait(2);
    self:spawn_default("N", 2, 4, 5);
    self:spawn_default("E", 1, 5);
    self:spawn_default("W", 2, 4);
    self:spawn_default("S", 1);
    self:wait(2);
    self:spawn_default("N", 3, 4);
    self:spawn_default("E", 2, 4, 5);
    self:spawn_default("W", 3);
    self:spawn_default("S", 2, 5);
    self:wait(3);
    self:spawn_default("N", 1, 3);
    self:spawn_default("E", 1, 2);
    self:spawn_default("W", 3, 4);
    self:spawn_default("S", 2, 4);
end

local pattern_boulder = function(self)
    self:spawn_default("E", 2, 3, 4, 5);
    self:wait(1.4);
    for i = 1, 4 do
        self:spawn_fast("W", i);
        self:wait(0.35);
    end
    
    self:wait(1.1);
    self:spawn_default("S", 1, 2, 3, 4);
    self:wait(1.4);
    for i = 5, 2, -1 do
        self:spawn_fast("N", i);
        self:wait(0.35);
    end

    self:wait(1.1);
    self:spawn_default("W", 2, 3, 4, 5);
    self:wait(1.4);
     for i = 1, 4 do
        self:spawn_fast("E", i);
        self:wait(0.35);
    end

end

local pattern_rain = function(self)
    local a = self:thread(function(self)
        for i = 1, 100 do
            self:spawn_fast("S", 1 + (i*43)%5);
            self:wait(1);
        end
    end);

    for i = 9, 14 do
        for j = 1, 3 do
            local d = i%3 == 0 and "E" or i%3 == 1 and "W" or "N";
            self:spawn_default(d, 1 + (2*i + 17*j)%87%5);
            self:wait(0.4);
        end
        self:wait(2);
    end

    a:stop();
end

local pattern_frogger = function(self)
    self:spawn_default("W", 1, 2, 3, 4);
    
    self:wait(1.5);
    local cars = self:thread(function(self)
        while true do
            self:spawn_fast("E", 2, 4);
            self:spawn_fast("W", 2, 4);
            self:wait(0.9);
        end
    end);
    
    self:wait(1);
    self:spawn_default("W", 1, 5);
    self:wait(1.8);
    self:spawn_default("W", 3, 5);
    self:wait(1.8);
    self:spawn_default("W", 1, 5);
    self:wait(1.8);

    cars:stop();
    self:spawn_default("E", 3);
end

local level_1 = function(self)
    while true do
        self:wait(2);

        -- -- Easy
        -- pattern_baby(self);
        -- self:wait(3);
        -- pattern_blocks(self);
        -- self:wait(3);
        -- pattern_squares(self);
        -- self:wait(3);
        -- pattern_slow_trick(self);
        -- self:wait(3);
        -- pattern_fast_intro(self);
        -- self:wait(3);
        
        -- -- Medium
        -- pattern_rain(self);
        -- self:wait(3);
        -- pattern_gaps(self);
        -- self:wait(3);
        -- pattern_modulo(self);
        -- self:wait(3);
        -- pattern_zebulon(self);
        -- self:wait(3);
        -- pattern_stagger_duos(self);
        -- self:wait(3);
        -- pattern_full_rotate(self);
        -- self:wait(3);
        -- pattern_boulder(self);
        -- self:wait(3);
        -- pattern_ones_and_threes(self);
        -- self:wait(3);
        -- pattern_coverage(self);
        -- self:wait(3);
        -- pattern_sin(self);
        -- self:wait(3);

        -- -- Hard
        pattern_chaos_engine(self);
        self:wait(3);
        pattern_bomberman(self);
        self:wait(3);
        pattern_frogger(self);
        self:wait(3);
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

Arena.spawn_default = function(self, origin, ...)
    local lanes = {...};
    for _, lane in ipairs(lanes) do
        self:spawn("FishDefault", origin, lane);    
    end
end

Arena.spawn_fast = function(self, origin, ...)
    local lanes = {...};
    for _, lane in ipairs(lanes) do
        self:spawn("FishFast", origin, lane);    
    end
end

return Arena;
