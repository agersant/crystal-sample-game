local HitWidget = require("arpg/field/hud/damage/HitWidget");
local Entity = require("ecs/Entity");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local WorldWidget = require("mapscene/display/WorldWidget");
local Parent = require("mapscene/physics/Parent");
local PhysicsBody = require("mapscene/physics/PhysicsBody");
local Script = require("script/Script");

local HitWidgetEntity = Class("HitWidgetEntity", Entity);

HitWidgetEntity.init = function(self, scene, victim, amount)
	assert(amount);
	HitWidgetEntity.super.init(self, scene);

	local hitWidget = HitWidget:new(amount);
	self:addComponent(PhysicsBody:new(scene:getPhysicsWorld()));
	self:addComponent(WorldWidget:new(hitWidget));
	self:addComponent(Parent:new(victim));
	self:addComponent(ScriptRunner:new());

	self:addScript(Script:new(function(self)
		self:join(hitWidget:animate());
		self:despawn();
	end));
end

return HitWidgetEntity;
