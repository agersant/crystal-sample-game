local Stat = Class("Stat");

Stat.init = function(self, baseValue, minValue, maxValue)
	self._min = minValue;
	self._max = maxValue;
	self._modifiers = {};
	assert(baseValue);
	self:setBaseValue(baseValue);
end

Stat.setBaseValue = function(self, value)
	if self._min and self._max then
		self._value = math.clamp(value, self._min, self._max);
	elseif self._min then
		self._value = math.max(value, self._min);
	elseif self._max then
		self._value = math.min(value, self._max);
	else
		self._value = value;
	end
end

Stat.getBaseValue = function(self)
	return self._value;
end

Stat.getMinValue = function(self)
	return self._min;
end

Stat.getMaxValue = function(self)
	return self._max;
end

Stat.substract = function(self, amount)
	self:setBaseValue(self._value - amount);
end

Stat.add = function(self, amount)
	self:setBaseValue(self._value + amount);
end

return Stat;
