local Player = Class("Player", crystal.Entity);

Player.init = function(self)
    self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(6));
	self:set_categories("player");

    self:add_component(crystal.AnimatedSprite, crystal.assets.get("assets/hero.json"));
    self:set_texture(texture);
    self:set_draw_offset(0, -8);
    self:set_draw_order_modifier("replace", 1);

    self:add_component(crystal.InputListener, 1);
    self:add_component(crystal.Movement);
    self:add_component("MovementControls");
    self:set_speed(75);
    
    self:add_component(crystal.ScriptRunner);
    self:add_script(function(self)
        while true do
            local r = self:rotation();
            local dx, dy = math.angle_to_cardinal(r);
            local d = dx == 1 and "E" or dx == -1 and "W" or dy == 1 and "S" or "N";
            self:set_animation("idle", d);
            self:wait_frame();
        end
    end);
end

return Player;