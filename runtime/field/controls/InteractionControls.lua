local InteractionControls = Class("InteractionControls", crystal.Behavior);

local scriptFunction = function(self)
	self:defer(self:add_input_handler(function(input)
		if input == "+interact" then
			self:signal(input);
			return true;
		end
	end));

	while true do
		self:wait_for("+interact");
		local actor = self:component("Actor");
		if not actor or actor:isIdle() then
			local collider = self:component(crystal.Collider);
			if collider then
				for _, entity in pairs(collider:active_contacts()) do
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
