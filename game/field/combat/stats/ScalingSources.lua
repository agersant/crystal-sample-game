local Stats = require("field/combat/stats/Stats");

local ScalingSources = {};

for name, value in pairs(Stats) do
	ScalingSources[name] = value;
end

local nextIndex = table.count(Stats) + 1;

ScalingSources.MISSING_HEALTH = nextIndex;
nextIndex = nextIndex + 1;

return ScalingSources;
