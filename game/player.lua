local Player = Class("Player", crystal.Entity);

Player.init = function(self)
    self:add_component(crystal.Body);
	local collider = self:add_component(crystal.Collider, love.physics.newCircleShape(6));
	collider:set_categories("player");
	collider:enable_collision_with("enemy");
    collider.on_collide = function(self, other_component, other_entity, contact)
        if not other_entity:inherits_from("Fish") then
            return;
        end
        local player = self:entity();
        local scene = player:ecs():context("scene");
        player:disable_collision_with("enemy");
        scene:on_player_hit(self:entity(), other_entity);
    end

    self:add_component("YDrawOrder");

    self:add_component(crystal.AnimatedSprite, crystal.assets.get("assets/hero.json"));
    self:set_texture(texture);
    self:set_draw_offset(0, -10);

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

Player.reset = function(self)
    self:enable_collision_with("enemy");
end

return Player;