local Fish = Class("Fish", crystal.Entity);
local FishDefault = Class("FishDefault", Fish);
local FishFast = Class("FishFast", Fish);

local forward_from = {
    W = 0,
    E = math.pi,
    N = math.pi / 2,
    S = -math.pi / 2,
};

local orientation_from = {
    W = "E",
    E = "W",
    N = "S",
    S = "N",
};

Fish.init = function(self, side, lane, sheet)
    assert(sheet);

    self.forward = forward_from[side];
    assert(self.forward);
    local dx, dy = math.angle_to_cardinal(self.forward);

    local n = 24;
    self:add_component(crystal.Body);    
    self:set_position(-dx * n*3 + math.abs(dy) * (lane - 3) * n, -dy * n*3 + math.abs(dx) * (lane - 3) * n);

	local sensor = self:add_component(crystal.Sensor, love.physics.newCircleShape(10*dx, 10*dy, 8));
	sensor:set_categories("enemy");
	sensor:enable_activation_by("player");
    sensor:disable_sensor();
    sensor.on_activate = function(self, other_component, other_entity, contact)
        self:entity():bonk();
    end

    self:add_component(crystal.AnimatedSprite, sheet);
    self:play_animation("swim", orientation_from[side]);
    self:set_draw_order_modifier("replace", 1);

    self:add_component("Altitude");

    self:add_component(crystal.Movement);
    
    self:add_component(crystal.ScriptRunner);

    local forward = self.forward;
    self:add_script(function(self)
        local dx, dy = math.angle_to_cardinal(forward);
        local can_sink = false;
        local exit_location = 3.2 * 24;
        self:thread(function(self)
            self:wait_for("allow_sink");
            can_sink = true;
        end);
        while true do
            self:wait_frame();
            local x, y = self:position();
            local altitude = self:altitude();
            local finished_travel = math.max(dx*x, dy*y) > exit_location;
            local is_on_water = math.max(math.abs(x), math.abs(y)) > exit_location;
            if altitude < 5 and (finished_travel or (can_sink and is_on_water)) then
                break;
            end
        end
        self:despawn();
    end);
end

Fish.bonk = function(self)
    local forward = self.forward;
    self:signal_all_scripts("bonk");
    self:add_script(function(self)
        self:set_heading(forward + math.pi);
        self:set_speed(60);
        self:wait_tween(0, 30, 0.3, math.ease_out_quadratic, self.set_altitude, self)
        self:signal_all_scripts("allow_sink")
        self:wait_tween(30, 0, 0.3, math.ease_in_quadratic, self.set_altitude, self)
        self:set_speed(30);
        self:wait_tween(0, 12, 0.2, math.ease_out_quadratic, self.set_altitude, self)
        self:wait_tween(12, 0, 0.2, math.ease_in_quadratic, self.set_altitude, self)
        self:set_speed(15);
        self:wait_tween(0, 4, 0.1, math.ease_out_quadratic, self.set_altitude, self)
        self:wait_tween(4, 0, 0.1, math.ease_in_quadratic, self.set_altitude, self)
        self:set_speed(8);
        self:wait_tween(0, 2, 0.1, math.ease_out_quadratic, self.set_altitude, self)
        self:wait_tween(2, 0, 0.1, math.ease_in_quadratic, self.set_altitude, self)
        self:set_speed(0);
        self:wait(0.4);
        self:set_heading(forward);
        self:set_speed(200);
    end);
end

FishDefault.init = function(self, side, lane)
    FishDefault.super.init(self, side, lane, crystal.assets.get("assets/fish.json"));
    
    local forward = self.forward;
    self:add_script(function(self)
        self:stop_on("bonk");
        self:wait_tween(-6, 4, 0.6, math.ease_out_quadratic, self.set_altitude, self)
        
        self:set_heading(forward + math.pi);
        self:wait_tween(10, 20, 0.3, math.ease_in_out_quadratic, self.set_speed, self)
        self:wait_tween(20, 0, 0.4, math.ease_in_out_quartic, self.set_speed, self)
        self:wait(0.2);

        self:enable_sensor();
        self:set_heading(forward);
        self:set_speed(180);
    end);
end

FishFast.init = function(self, side, lane)
    FishDefault.super.init(self, side, lane, crystal.assets.get("assets/fish_fast.json"));

    local forward = self.forward;
    self:add_script(function(self)
        self:set_speed(5);
        self:set_heading(forward + math.pi);
        self:wait_tween(-6, 4, 0.8, math.ease_out_quadratic, self.set_altitude, self)
        
        self:enable_sensor();
        self:set_heading(forward);
        self:set_speed(360);
    end);
end

return {
    FishDefault = FishDefault,
    FishFast = FishFast,
};