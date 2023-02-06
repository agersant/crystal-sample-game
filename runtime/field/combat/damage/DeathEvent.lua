local Event = require("ecs/Event");

local DeathEvent = Class("DeathEvent", Event);

DeathEvent.init = function(self, entity)
	DeathEvent.super.init(self, entity);
end

return DeathEvent;
