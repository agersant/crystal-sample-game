local OnHitEffect = require("field/combat/effects/OnHitEffect");
local Flinch = require("field/combat/hit-reactions/Flinch");
local FlinchAmounts = require("field/combat/hit-reactions/FlinchAmounts");

local FlinchEffect = Class("FlinchEffect", OnHitEffect);

FlinchEffect.init = function(self, amount)
	FlinchEffect.super.init(self);
	self._amount = amount or FlinchAmounts.SMALL;
end

FlinchEffect.apply = function(self, attacker, victim, damage)
	local attacker = attacker:entity();
	local victim = victim:entity();
	local flinch = victim:component(Flinch);
	if flinch then
		flinch:beginFlinch(attacker:getAngle(), self._amount);
	end
end

return FlinchEffect;
