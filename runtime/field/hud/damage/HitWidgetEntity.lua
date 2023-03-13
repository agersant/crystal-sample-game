local HitWidget = require("field/hud/damage/HitWidget");
local WorldWidget = require("mapscene/display/WorldWidget");

local HitWidgetEntity = Class("HitWidgetEntity", crystal.Entity);

HitWidgetEntity.init = function(self, victim, amount)
	assert(amount);
	local scene = self:ecs();
	local hitWidget = HitWidget:new(amount);
	self:add_component(crystal.Body, "dynamic");
	self:add_component(WorldWidget, hitWidget);
	self:add_component(crystal.ScriptRunner);
	self:attach_to(victim);

	self:add_script(function(self)
		self:join(hitWidget:animate());
		self:despawn();
	end);
end

return HitWidgetEntity;
