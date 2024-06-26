local MovementControls = require("field/controls/MovementControls");

local MovementControlsSystem = Class("MovementControlsSystem", crystal.System);

MovementControlsSystem.init = function(self)
	self._withMovement = self:add_query({ crystal.InputListener, crystal.Movement, MovementControls });
end

MovementControlsSystem.apply_movement_controls = function(self, dt)
	local entities = self._withMovement:entities();
	for entity in pairs(entities) do
		local movementControls = entity:component(MovementControls);

		local player_index = entity:player_index();
		local left = crystal.input.is_action_down(player_index, "moveLeft");
		local right = crystal.input.is_action_down(player_index, "moveRight");
		local up = crystal.input.is_action_down(player_index, "moveUp");
		local down = crystal.input.is_action_down(player_index, "moveDown");

		local x, y;
		if left or right or up or down then
			if left and right then
				x = 0;
			else
				x = left and -1 or right and 1 or 0;
			end
			assert(x);

			if up and down then
				y = 0;
			else
				y = up and -1 or down and 1 or 0;
			end
			assert(y);
		else
			local stick_x = crystal.input.axis_action_value(player_index, "moveX");
			local stick_y = crystal.input.axis_action_value(player_index, "moveY");
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
			local rotation = math.atan2(y, x);
			entity:set_heading(rotation);
		else
			entity:set_heading(nil);
		end
	end
end

return MovementControlsSystem;
