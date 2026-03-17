local Player = Class("Player", crystal.Entity);

Player.init = function(self)
    self:add_component(crystal.Body);
	self:add_component(crystal.Collider, love.physics.newCircleShape(6));
	self:set_categories("solid");

    self:add_component(crystal.Sprite);
    self:set_texture(crystal.assets.get("assets/player.png"));
end

return Player;