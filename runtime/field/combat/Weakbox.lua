local HitEvent = require("field/combat/HitEvent");

local Weakbox = Class("Weakbox", crystal.Sensor);

Weakbox.init = function(self, body, shape)
	Weakbox.super.init(self, body, shape);
	self:set_categories("weakbox");
	self:enable_activation_by("hitbox");
end

return Weakbox;
