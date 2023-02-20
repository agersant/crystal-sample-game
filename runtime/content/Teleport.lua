local PartyMember = require("persistence/party/PartyMember");
local MapSystem = require("mapscene/MapSystem");
local TouchTrigger = require("mapscene/physics/TouchTrigger");
local StringUtils = require("utils/StringUtils");
local Field = require("field/Field");

local Teleport = Class("Teleport", crystal.Entity);
local TeleportTouchTrigger = Class("TeleportTouchTrigger", TouchTrigger);

local doTeleport = function(self, triggeredBy)
	local teleportEntity = self:entity();
	local finalX, finalY = teleportEntity._targetX, teleportEntity._targetY;

	local targetMap = StringUtils.mergePaths(crystal.conf.mapDirectory, teleportEntity._targetMap);
	local newScene = Field:new(targetMap, finalX, finalY, self:getAngle());
	ENGINE:loadScene(newScene);
end

local teleportScript = function(self)
	local teleportEntity = self:entity();
	self:end_on("teleportActivated");
	while true do
		local triggeredBy = self:wait_for("+trigger");
		local watchDirectionThread = self:thread(function(self)
			while true do
				self:wait_frame();
				if triggeredBy:component(PartyMember) then
					local teleportAngle = teleportEntity:getAngle();
					local entityAngle = triggeredBy:getAngle();
					local correctDirection = math.abs(teleportAngle - entityAngle) < math.pi / 2;
					if correctDirection then
						doTeleport(self, triggeredBy);
						self:signal("teleportActivated");
					end
				end
			end
		end);
		self:thread(function(self)
			while true do
				local noLongerTriggering = self:wait_for("-trigger");
				if noLongerTriggering == triggeredBy then
					watchDirectionThread:stop();
					break
				end
			end
		end);
	end
end

TeleportTouchTrigger.init = function(self, physicsBody, shape)
	TeleportTouchTrigger.super.init(self, physicsBody, shape);
end

TeleportTouchTrigger.onBeginTouch = function(self, component)
	self:entity():signal_all_scripts("+trigger", component:entity());
end

TeleportTouchTrigger.onEndTouch = function(self, component)
	self:entity():signal_all_scripts("-trigger", component:entity());
end

Teleport.init = function(self, options)
	local scene = self:ecs();
	assert(options.targetMap);
	assert(options.targetX);
	assert(options.targetY);

	local physicsBody = self:add_component("PhysicsBody", scene:getPhysicsWorld());
	self:add_component(TeleportTouchTrigger, physicsBody, options.shape);
	self:add_component("ScriptRunner");
	self:add_script(teleportScript);

	self._targetMap = options.targetMap;
	self._targetX = options.targetX;
	self._targetY = options.targetY;

	local map = scene:getMap();
	local mapWidth = map:getWidthInPixels();
	local mapHeight = map:getHeightInPixels();

	local left = math.abs(options.x);
	local top = math.abs(options.y);
	local right = math.abs(mapWidth - options.x);
	local bottom = math.abs(mapHeight - options.y);
	local dx = math.min(left, right);
	local dy = math.min(top, bottom);

	if dx < dy then
		if left < right then
			self:setAngle(math.pi);
		else
			self:setAngle(0);
		end
	else
		if top < bottom then
			self:setAngle( -math.pi / 2);
		else
			self:setAngle(math.pi / 2);
		end
	end
end

return Teleport;
