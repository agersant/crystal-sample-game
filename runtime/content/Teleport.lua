local Field = require("field/Field");

local Teleport = Class("Teleport", crystal.Entity);
local TeleportTouchTrigger = Class("TeleportTouchTrigger", crystal.Sensor);

local doTeleport = function(self, triggeredBy)
	local teleport_entity = self:entity();
	local final_x, final_y = teleport_entity._target_x, teleport_entity._target_y;

	local target_map = string.merge_paths(crystal.conf.mapDirectory, teleport_entity._target_map);
	local new_scene = Field:new(target_map, final_x, final_y, self:rotation());
	crystal.scene.replace(new_scene, crystal.Transition.FadeToBlack:new(), crystal.Transition.FadeFromBlack:new());
end

local teleportScript = function(self)
	local teleportEntity = self:entity();
	self:stop_on("teleportActivated");
	while true do
		local triggeredBy = self:wait_for("+trigger");
		local watchDirectionThread = self:thread(function(self)
			while true do
				self:wait_frame();
				if triggeredBy:component("PartyMember") then
					local teleportAngle = teleportEntity:rotation();
					local entityAngle = triggeredBy:rotation();
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

TeleportTouchTrigger.init = function(self, shape)
	TeleportTouchTrigger.super.init(self, shape);
	self:set_categories("trigger");
	self:enable_activation_by("solid");
end

TeleportTouchTrigger.on_begin_contact = function(self, component)
	self:entity():signal_all_scripts("+trigger", component:entity());
end

TeleportTouchTrigger.on_end_contact = function(self, component)
	self:entity():signal_all_scripts("-trigger", component:entity());
end

Teleport.init = function(self, options)
	assert(options.target_map);
	assert(options.target_x);
	assert(options.target_y);

	self:add_component(crystal.Body);
	self:add_component(TeleportTouchTrigger, options.shape);
	self:add_component("ScriptRunner");
	self:add_script(teleportScript);

	self._target_map = options.target_map;
	self._target_x = options.target_x;
	self._target_y = options.target_y;

	local map = self:context("map");
	local mapWidth, mapHeight = map:pixel_size();

	local left = math.abs(options.x);
	local top = math.abs(options.y);
	local right = math.abs(mapWidth - options.x);
	local bottom = math.abs(mapHeight - options.y);
	local dx = math.min(left, right);
	local dy = math.min(top, bottom);

	if dx < dy then
		if left < right then
			self:set_rotation(math.pi);
		else
			self:set_rotation(0);
		end
	else
		if top < bottom then
			self:set_rotation(-math.pi / 2);
		else
			self:set_rotation(math.pi / 2);
		end
	end
end

return Teleport;
