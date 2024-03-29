local DamageTypes = require("field/combat/damage/DamageTypes");
local Elements = require("field/combat/damage/Elements");

local Stats = { MOVEMENT_SPEED = 1, HEALTH = 2, MAX_HEALTH = 3 };

local nextIndex = table.count(Stats) + 1;
for name in pairs(DamageTypes) do
	Stats["OFFENSE_" .. name] = nextIndex;
	Stats["DEFENSE_" .. name] = nextIndex + 1;
	nextIndex = nextIndex + 2;
end

local nextIndex = table.count(Stats) + 1;
for name in pairs(Elements) do
	Stats["AFFINITY_" .. name] = nextIndex;
	Stats["RESISTANCE_" .. name] = nextIndex + 1;
	nextIndex = nextIndex + 2;
end

return Stats;
