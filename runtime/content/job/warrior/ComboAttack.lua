local FlinchAmounts = require("field/combat/hit-reactions/FlinchAmounts");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");
local DamageUnit = require("field/combat/damage/DamageUnit");
local Skill = require("field/combat/skill/Skill");

local ComboAttack = Class("ComboAttack", Skill);

local getComboSwingAction = function(swingCount)
	return function(self)
		if swingCount == 1 or swingCount == 3 then
			self:tween(200, 0, 0.20, "inQuadratic", function(speed)
				self:set_heading(self:rotation());
				self:set_speed(speed);
			end);
		else
			self:set_speed(0);
		end

		self:resetMultiHitTracking();
		local flinchAmount = swingCount == 3 and FlinchAmounts.LARGE or FlinchAmounts.SMALL;
		local onHitEffects = { FlinchEffect:new(flinchAmount) };
		self:setDamagePayload({ DamageUnit:new(1) }, onHitEffects);

		self:join(self:playAnimation("attack_" .. swingCount, self:cardinal_direction(), true));
	end
end

local performCombo = function(self)
	self:stop_on("disrupted");
	local comboCounter = 0;
	while self:isIdle() and comboCounter < 4 do
		local swing = self:doAction(getComboSwingAction(comboCounter));
		comboCounter = comboCounter + 1;
		local didInputNextMove = false;
		local inputWatch = self:thread(function(self)
			self:wait_for("+useSkill");
			didInputNextMove = true;
		end);
		if not self:join(swing) or not self:isIdle() then
			break
		end
		if not inputWatch:is_dead() then
			inputWatch:stop();
		end
		if not didInputNextMove then
			break
		end
	end
end

local comboAttackScript = function(self)
	while true do
		self:wait_for("+useSkill");
		local comboThread = self:thread(performCombo);
		local finished = self:join(comboThread);
		if not finished then
			self:stopAction();
		end
	end
end

ComboAttack.init = function(self, skillSlot)
	ComboAttack.super.init(self, skillSlot, comboAttackScript);
end

return ComboAttack;
