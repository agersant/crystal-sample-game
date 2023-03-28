local DamageEvent = require("field/combat/damage/DamageEvent");
local HitWidget = require("field/hud/damage/HitWidget");

local DamageNumbersSystem = Class("DamageNumbersSystem", crystal.System);

DamageNumbersSystem.after_run_scripts = function(self, dt)
	for _, event in pairs(self:ecs():events(DamageEvent)) do
		local victim = event:entity();
		assert(victim);
		local amount = event:getDamage():getTotal();
		assert(amount);

		local widget = HitWidget:new(amount);
		local component = victim:add_component(crystal.WorldWidget, widget);
		component:set_draw_order("replace", math.huge);
		widget:script():add_thread(function(self)
			self:join(widget:animate());
			victim:remove_component(component);
		end);
	end
end

return DamageNumbersSystem;
