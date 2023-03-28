local Weakbox = Class("Weakbox", crystal.Sensor);

Weakbox.init = function(self, shape)
	Weakbox.super.init(self, shape);
	self:set_categories("weakbox");
	self:enable_activation_by("hitbox");
end

return Weakbox;
