local Actor = require("mapscene/behavior/Actor");
local InputListener = require("mapscene/behavior/InputListener");
local Collision = require("mapscene/physics/Collision");

local InteractionControls = Class("InteractionControls", crystal.Behavior);

local scriptFunction = function(self)
	while true do
		local inputListener = self:component(InputListener);
		if not inputListener then
			self:wait_frame();
		end
		local inputDevice = inputListener:getInputDevice();
		assert(inputDevice);

		if inputDevice:isCommandActive("interact") then
			self:wait_for("-interact");
		end
		self:wait_for("+interact");

		local actor = self:component(Actor);
		if not actor or actor:isIdle() then
			local collision = self:component(Collision);
			if collision then
				for entity in pairs(collision:getContactEntities()) do
					local scriptRunner = entity:component(crystal.ScriptRunner);
					if scriptRunner then
						scriptRunner:signal_all_scripts("interact", self:entity());
					end
				end
			end
		end
	end
end

InteractionControls.init = function(self)
	InteractionControls.super.init(self, scriptFunction)
end

return InteractionControls;
