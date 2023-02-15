local HitEvent = require("field/combat/HitEvent");
local Hitbox = require("mapscene/physics/Hitbox");

local CombatHitbox = Class("CombatHitbox", Hitbox);

CombatHitbox.init = function(self, entity, physicsBody)
	CombatHitbox.super.init(self, entity, physicsBody);
	self._targetsHit = {};
end

CombatHitbox.resetMultiHitTracking = function(self)
	self._targetsHit = {};
end

CombatHitbox.onBeginTouch = function(self, weakbox)
	CombatHitbox.super.onBeginTouch(self, weakbox);
	local target = weakbox:entity();
	if not self._targetsHit[target] then
		self._targetsHit[target] = true;
		self:entity():create_event(HitEvent, target);
	end
end

return CombatHitbox;
