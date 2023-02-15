local Actor = require("mapscene/behavior/Actor");
local Behavior = require("mapscene/behavior/Behavior");
local InputListener = require("mapscene/behavior/InputListener");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Collision = require("mapscene/physics/Collision");

local InteractionControls = Class("InteractionControls", Behavior);

local scriptFunction = function(self)
	while true do
		local inputListener = self:component(InputListener);
		if not inputListener then
			self:waitFrame();
		end
		local inputDevice = inputListener:getInputDevice();
		assert(inputDevice);

		if inputDevice:isCommandActive("interact") then
			self:waitFor("-interact");
		end
		self:waitFor("+interact");

		local actor = self:component(Actor);
		if not actor or actor:isIdle() then
			local collision = self:component(Collision);
			if collision then
				for entity in pairs(collision:getContactEntities()) do
					local scriptRunner = entity:component(ScriptRunner);
					if scriptRunner then
						scriptRunner:signalAllScripts("interact", self:entity());
					end
				end
			end
		end
	end
end

InteractionControls.init = function(self, entity)
	InteractionControls.super.init(self, entity, scriptFunction)
end

return InteractionControls;
