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

		local inputListener = entity:component(crystal.InputListener);
		local left = inputListener:is_input_down("moveLeft") and not disabled;
		local right = inputListener:is_input_down("moveRight") and not disabled;
		local up = inputListener:is_input_down("moveUp") and not disabled;
		local down = inputListener:is_input_down("moveDown") and not disabled;

		movementControls:setIsInputtingLeft(left);
		movementControls:setIsInputtingRight(right);
		movementControls:setIsInputtingUp(up);
		movementControls:setIsInputtingDown(down);

		local locomotion = entity:component(Locomotion);

		if left or right or up or down then
			local xDir, yDir;

			if left and right then
				xDir = movementControls:getLastXInput() or 0;
			else
				xDir = left and -1 or right and 1 or 0;
			end
			assert(xDir);

			if up and down then
				yDir = movementControls:getLastYInput() or 0;
			else
				yDir = up and -1 or down and 1 or 0;
			end
			assert(yDir);

			local angle = math.atan2(yDir, xDir);
			locomotion:setMovementAngle(angle);
		else
			locomotion:setMovementAngle(nil);
		end
	end
end

return MovementControlsSystem;
