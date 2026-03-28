local Altitude = Class("Altitude", crystal.DrawEffect);

Altitude.init = function(self)
	self._altitude = 0;
end

Altitude.altitude = function(self)
	return self._altitude;
end

Altitude.set_altitude = function(self, altitude)
	assert(type(altitude) == "number");
	self._altitude = altitude;
end

Altitude.pre_draw = function(self)
	love.graphics.translate(0, -self._altitude);
end

return Altitude;
