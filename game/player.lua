local Player = Class("Player", crystal.Entity);

Player.init = function(self)
    self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(6));
	self:set_categories("solid");

    self:add_component(crystal.Sprite);
    local texture = crystal.assets.get("assets/player.png");
    self:set_texture(texture);
    self:set_draw_offset(-texture:getWidth()/2, 4 - texture:getHeight());
end

return Player;