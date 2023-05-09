local HitEvent = require("field/combat/HitEvent");

local Hitbox = Class("Hitbox", crystal.Sensor);

Hitbox.init = function(self, shape)
	Hitbox.super.init(self, shape);
	self:set_categories("hitbox");
	self:enable_activation_by("weakbox");
end

Hitbox.on_begin_contact = function(self, weakbox)
	local target = weakbox:entity();
	self:entity():create_event(HitEvent, target);
end

return Hitbox;
