local MovementControls = require("field/controls/MovementControls");
local Locomotion = require("mapscene/physics/Locomotion");

local MovementControlsSystem = Class("MovementControlsSystem", crystal.System);

MovementControlsSystem.init = function(self)
	self._withLocomotion = self:add_query({ crystal.InputListener, Locomotion, MovementControls });
end

MovementControlsSystem.before_run_scripts = function(self, dt)
	local entities = self._withLocomotion:entities();
	for entity in pairs(entities) do
		local movementControls = entity:component(MovementControls);
		local disabled = movementControls:is_movement_disabled();

		local inputPlayer = entity:input_player();
		local left = inputPlayer:is_action_input_down("moveLeft");
		local right = inputPlayer:is_action_input_down("moveRight");
		local up = inputPlayer:is_action_input_down("moveUp");
		local down = inputPlayer:is_action_input_down("moveDown");

		local x, y;
		if not disabled then
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
				local stick_x = inputPlayer:action_axis_value("moveX");
				local stick_y = inputPlayer:action_axis_value("moveY");
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
		end

		if x and y then
			local angle = math.atan2(y, x);
			entity:setMovementAngle(angle);
		else
			entity:setMovementAngle(nil);
		end
	end
end

return MovementControlsSystem;
