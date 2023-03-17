local DamageIntent = Class("DamageIntent", crystal.Component);

DamageIntent.init = function(self)
	self._units = {};
	self._onHitEffects = {};
	self._targetsHit = {};
end

DamageIntent.setDamagePayload = function(self, units, onHitEffects)
	assert(type(units) == "table");
	self._units = units or {};
	self._onHitEffects = onHitEffects or {};
end

DamageIntent.getDamageUnits = function(self)
	local units = {};
	for _, u in ipairs(self._units) do
		units[u] = true;
	end
	return units;
end

DamageIntent.getOnHitEffects = function(self)
	return table.copy(self._onHitEffects);
end

DamageIntent.resetMultiHitTracking = function(self)
	self._targetsHit = {};
end

DamageIntent.registerHit = function(self, entity)
	self._targetsHit[entity] = true;
end

DamageIntent.wasEntityHit = function(self, entity)
	return self._targetsHit[entity];
end

return DamageIntent;
