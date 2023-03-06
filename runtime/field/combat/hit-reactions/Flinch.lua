local FlinchAmounts = require("field/combat/hit-reactions/FlinchAmounts");

local Flinch = Class("Flinch", crystal.Component);

local smallFlinch = function(self, direction)
	self:defer(function(self)
		self:enable_movement();
		self:set_damping(0);
		self:enable_collision_with("solid");
		self:set_restitution(0);
		self:set_altitude(0);
	end);
	self:disable_movement();
	self:set_velocity(0, 0);
	self:set_damping(20);
	self:disable_collision_with("solid");
	self:set_restitution(0.4);

	local dx = math.cos(direction);
	local dy = math.sin(direction);
	self:apply_linear_impulse(300 * dx, 300 * dy);

	self:wait_tween(0, 6, 0.1, "outCubic", self.set_altitude, self);
	self:wait_tween(6, 0, 0.1, "inCubic", self.set_altitude, self);

	self:wait(0.1);
end

local largeFlinch = function(self, direction)
	self:defer(function(self)
		self:enable_movement();
		self:set_damping(0);
		self:enable_collision_with("solid");
		self:set_restitution(0);
		self:set_altitude(0);
	end);
	self:disable_movement();
	self:set_velocity(0, 0);
	self:set_damping(4);
	self:disable_collision_with("solid");
	self:set_restitution(0.4);

	self:wait(6 * 1 / 60);

	local dx = math.cos(direction);
	local dy = math.sin(direction);

	self:apply_linear_impulse(400 * dx, 400 * dy);

	self:wait_tween(0, 16, 0.15, "outQuadratic", self.set_altitude, self);
	self:wait_tween(16, 0, 0.15, "inQuadratic", self.set_altitude, self);
	self:wait_tween(0, 4, 0.1, "outQuadratic", self.set_altitude, self);
	self:wait_tween(4, 0, 0.1, "inQuadratic", self.set_altitude, self);
	self:wait_tween(0, 2, 0.08, "outQuadratic", self.set_altitude, self);
	self:wait_tween(2, 0, 0.08, "inQuadratic", self.set_altitude, self);

	self:wait(0.6);
end

Flinch.beginFlinch = function(self, direction, amount)
	assert(direction);
	assert(amount);
	if self._flinchAmount and self._flinchAmount > amount then
		return;
	end

	local entity = self:entity();
	assert(entity:component("Actor"));
	assert(entity:component(crystal.Body));

	if entity:isIdle() or self._flinchAmount then
		entity:stopAction();
		if amount == FlinchAmounts.LARGE then
			entity:doAction(function(self)
				self:defer(self:setFlinchAmount(amount));
				largeFlinch(self, direction)
			end);
		else
			entity:doAction(function(self)
				self:defer(self:setFlinchAmount(amount));
				smallFlinch(self, direction)
			end);
		end
	end
end

Flinch.getFlinchAmount = function(self, amount)
	return self._flinchAmount;
end

Flinch.setFlinchAmount = function(self, amount)
	self._flinchAmount = amount;
	return function()
		self:setFlinchAmount();
	end
end

return Flinch;
