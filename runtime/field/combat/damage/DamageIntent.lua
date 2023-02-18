local TableUtils = require("utils/TableUtils");

local DamageIntent = Class("DamageIntent", crystal.Component);

DamageIntent.init = function(self)
	self._units = {};
	self._onHitEffects = {};
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
	return TableUtils.shallowCopy(self._onHitEffects);
end

return DamageIntent;
