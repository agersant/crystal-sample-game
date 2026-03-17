local Platform = Class("Platform", crystal.Entity);

Platform.init = function(self)
    local hs = 24 * 2.5 + 4;
    self:add_component(crystal.Body, "static");
	self:add_component(crystal.Collider, love.physics.newChainShape(true, -hs, -hs, hs, -hs, hs, hs, -hs, hs));
	self:set_categories("level");
    self:enable_collision_with("player");

    self:add_component(crystal.Sprite);
    local texture = crystal.assets.get("assets/platform.png");
    self:set_texture(texture);
    self:set_draw_offset(-texture:getWidth() / 2, -texture:getHeight() / 2);
    self:set_draw_order_modifier("replace", 0);
end

return Platform;