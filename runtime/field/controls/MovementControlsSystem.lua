local MovementControls = require("field/controls/MovementControls");

local MovementControlsSystem = Class("MovementControlsSystem", crystal.System);

MovementControlsSystem.init = function(self)
	self._withMovement = self:add_query({ crystal.InputListener, crystal.Movement, MovementControls });
end

MovementControlsSystem.before_run_scripts = function(self, dt)
	local entities = self._withMovement:entities();
	for entity in pairs(entities) do
		local movementControls = entity:component(MovementControls);

		local inputPlayer = entity:input_player();
		local left = inputPlayer:is_action_active("moveLeft");
		local right = inputPlayer:is_action_active("moveRight");
		local up = inputPlayer:is_action_active("moveUp");
		local down = inputPlayer:is_action_active("moveDown");

		local x, y;
		if left or right or up or down then
			if left and right then
				x = movementControls:getLastXInput() or 0;
			else
				x = left and -1 or right and 1 or 0;
			end
			assert(x);

			if up and down then
				y = movementControls:getLastYInput() or 0;
			else
				y = up and -1 or down and 1 or 0;
			end
			assert(y);
		else
			local stick_x = inputPlayer:axis_action_value("moveX");
			local stick_y = inputPlayer:axis_action_value("moveY");
			if math.abs(stick_x) < 0.2 then
				stick_x = 0;
			end
			if math.abs(stick_y) < 0.2 then
				stick_y = 0;
			end
			if math.abs(stick_x) > 0.5 or math.abs(stick_y) > 0.5 then
				x = stick_x;
				y = stick_y;
			end
		end

		if x and y then
			local angle = math.atan2(y, x);
			entity:set_heading(angle);
		else
			entity:set_heading(nil);
		end
	end
end

return MovementControlsSystem;
