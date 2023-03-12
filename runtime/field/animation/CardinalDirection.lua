local MathUtils = require("utils/MathUtils");

---@class CardinalDirection : Component
---@field private _cardinal_direction number # in radians
---@field private dir8_x number
---@field private dir8_y number
local CardinalDirection = Class("CardinalDirection", crystal.Component);

CardinalDirection.init = function(self)
	self._cardinal_direction = 0;
	self.dir8_x = nil;
	self.dir8_y = nil;
end

---@return number # in radians
CardinalDirection.cardinal_direction = function(self)
	return self._cardinal_direction;
end

---@private
---@param dir8_x number
---@param dir8_y number
CardinalDirection.update_cardinal_direction = function(self, rotation)
	local dir8_x, dir8_y = MathUtils.angleToDir8(rotation);
	assert(dir8_x == 0 or dir8_x == 1 or dir8_x == -1);
	assert(dir8_y == 0 or dir8_y == 1 or dir8_y == -1);
	assert(dir8_x ~= 0 or dir8_y ~= 0);

	if dir8_x == self.dir8_x and dir8_y == self.dir8_y then
		return;
	end

	if dir8_x * dir8_y == 0 then
		self._cardinal_direction = math.atan2(dir8_y, dir8_x);
	else
		if dir8_x ~= self.dir8_x then
			self._cardinal_direction = math.atan2(dir8_y, 0);
		end
		if dir8_y ~= self.dir8_y then
			self._cardinal_direction = math.atan2(0, dir8_x);
		end
	end

	self.dir8_x = dir8_x;
	self.dir8_y = dir8_y;
end

return CardinalDirection;
