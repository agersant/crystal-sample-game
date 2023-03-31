local Altitude = Class("Altitude", crystal.DrawEffect);

Altitude.init = function(self)
	self.altitude = 0;
end

Altitude.set_altitude = function(self, altitude)
	assert(type(altitude) == "number");
	self.altitude = altitude;
end

Altitude.pre_draw = function(self)
	love.graphics.translate(0, -self.altitude);
end

Altitude.post_draw = function(self)
	love.graphics.translate(0, self.altitude);
end

return Altitude;
