local Fish = Class("Fish", crystal.Entity);

local forward_from = {
    W = 0,
    E = math.pi,
    N = math.pi / 2,
};

local orientation_from = {
    W = "E",
    E = "W",
    N = "S",
    S = "N",
};

Fish.init = function(self, side, lane)
    local forward = forward_from[side];
    local dx, dy = math.angle_to_cardinal(forward);
    assert(forward);

    local n = 24;
    self:add_component(crystal.Body);    
    self:set_position(-dx * n*3 + math.abs(dy) * (lane - 3) * n, -dy * n*3 + math.abs(dx) * (lane - 3) * n);

	self:add_component(crystal.Collider, love.physics.newCircleShape(10, 0, 8));
	self:set_categories("enemy");

    self:add_component(crystal.AnimatedSprite, crystal.assets.get("assets/fish.json"));
    self:play_animation("swim", orientation_from[side]);
    self:set_draw_order_modifier("replace", 1);

    self:add_component("Altitude");

    self:add_component(crystal.Movement);
    
    self:add_component(crystal.ScriptRunner);
    self:add_script(function(self)
        self:wait_tween(-6, 4, 0.6, math.ease_out_quadratic, self.set_altitude, self)
        
        self:set_heading(forward + math.pi);
        self:wait_tween(10, 20, 0.3, math.ease_in_out_quadratic, self.set_speed, self)
        self:wait_tween(20, 0, 0.4, math.ease_in_out_quartic, self.set_speed, self)
        self:wait(0.2);

        self:set_heading(forward);
        self:wait_tween(0, 180, 0.2, math.ease_in_quadratic, self.set_speed, self)

        self:wait(3);
        self:despawn();
    end);
end

return Fish;