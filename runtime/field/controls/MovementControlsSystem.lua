local MovementControls = require("field/controls/MovementControls");
local InputListener = require("mapscene/behavior/InputListener");
local Locomotion = require("mapscene/physics/Locomotion");

local MovementControlsSystem = Class("MovementControlsSystem", crystal.System);

MovementControlsSystem.init = function(self, ecs)
	MovementControlsSystem.super.init(self, ecs);
	self._withLocomotion = self:ecs():add_query({ InputListener, Locomotion, MovementControls });
end

MovementControlsSystem.beforeScripts = function(self, dt)
	local entities = self._withLocomotion:entities();
	for entity in pairs(entities) do
		local inputListener = entity:component(InputListener);
		local left = inputListener:isCommandActive("moveLeft");
		local right = inputListener:isCommandActive("moveRight");
		local up = inputListener:isCommandActive("moveUp");
		local down = inputListener:isCommandActive("moveDown");

		local movementControls = entity:component(MovementControls);
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
