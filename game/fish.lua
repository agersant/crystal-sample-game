local Fish = Class("Fish", crystal.Entity);

Fish.init = function(self)
    self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(10, 0, 8));
	self:set_categories("enemy");

    self:add_component(crystal.Sprite);
    local texture = crystal.assets.get("assets/fish_e.png");
    self:set_texture(texture);
    self:set_draw_offset(-texture:getWidth() / 2, 4 - texture:getHeight());
    self:set_draw_order_modifier("replace", 1);

    self:add_component("Altitude");

    self:add_component(crystal.Movement);
    
    self:add_component(crystal.ScriptRunner);
    self:add_script(function(self)
        self:wait_tween(-6, 4, 0.6, math.ease_out_quadratic, self.set_altitude, self)
        
        self:set_heading(math.pi);
        self:wait_tween(10, 20, 0.3, math.ease_in_out_quadratic, self.set_speed, self)
        self:wait_tween(20, 0, 0.4, math.ease_in_out_quartic, self.set_speed, self)
        self:wait(0.2);

        self:set_heading(0);
        self:wait_tween(0, 180, 0.2, math.ease_in_quadratic, self.set_speed, self)

        self:wait(3);
        self:despawn();
    end);
end

return Fish;