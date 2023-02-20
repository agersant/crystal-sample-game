local HitWidget = require("field/hud/damage/HitWidget");
local WorldWidget = require("mapscene/display/WorldWidget");
local Parent = require("mapscene/physics/Parent");
local PhysicsBody = require("mapscene/physics/PhysicsBody");

local HitWidgetEntity = Class("HitWidgetEntity", crystal.Entity);

HitWidgetEntity.init = function(self, victim, amount)
	assert(amount);
	local scene = self:ecs();
	local hitWidget = HitWidget:new(amount);
	self:add_component(PhysicsBody, scene:getPhysicsWorld());
	self:add_component(WorldWidget, hitWidget);
	self:add_component(Parent, victim);
	self:add_component(crystal.ScriptRunner);

	self:add_script(function(self)
		self:join(hitWidget:animate());
		self:despawn();
	end);
end

return HitWidgetEntity;
