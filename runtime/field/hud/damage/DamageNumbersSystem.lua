local DamageEvent = require("field/combat/damage/DamageEvent");
local HitWidgetEntity = require("field/hud/damage/HitWidgetEntity");

local DamageNumbersSystem = Class("DamageNumbersSystem", crystal.System);

DamageNumbersSystem.after_run_scripts = function(self, dt)
	for _, event in pairs(self:ecs():events(DamageEvent)) do
		local victim = event:entity();
		assert(victim);
		local amount = event:getDamage():getTotal();
		assert(amount);
		self:ecs():spawn(HitWidgetEntity, victim, amount);
	end
end

return DamageNumbersSystem;
