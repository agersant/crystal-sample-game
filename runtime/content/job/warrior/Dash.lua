local DamageUnit = require("field/combat/damage/DamageUnit");
local FlinchAmounts = require("field/combat/hit-reactions/FlinchAmounts");
local FlinchEffect = require("field/combat/hit-reactions/FlinchEffect");
local Skill = require("field/combat/skill/Skill");

local Dash = Class("Dash", Skill);

local action = function(self)
	local buildupDuration = 0.36;
	local buildupPeakSpeed = 90;
	local dashDuration = 0.2;
	local peakSpeed = 1200;
	local recoveryBeginSpeed = 60;
	local recoveryDuration = 0.2;

	self:defer(self:disable_movement());

	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new(FlinchAmounts.LARGE) };
	self:setDamagePayload({ DamageUnit:new(10) }, onHitEffects);

	self:setAnimation("dash", self:cardinal_direction());

	local rotation = self:rotation();
	local dx = math.cos(rotation);
	local dy = math.sin(rotation);

	self:wait_tween(buildupPeakSpeed, 0, buildupDuration, math.ease_out_cubic, function(speed)
		self:set_velocity(-dx * speed, -dy * speed);
	end);
	self:wait_tween(peakSpeed, recoveryBeginSpeed, dashDuration, math.ease_out_quartic, function(speed)
		self:set_velocity(dx * speed, dy * speed);
	end);
	self:wait_tween(recoveryBeginSpeed, 0, recoveryDuration, math.ease_out_quadratic, function(speed)
		self:set_velocity(dx * speed, dy * speed);
	end);
end

local dashScript = function(self)
	while true do
		self:wait_for("+useSkill");
		if self:isIdle() then
			self:doAction(action);
		end
	end
end

Dash.init = function(self, skillSlot)
	Dash.super.init(self, skillSlot, dashScript);
end

return Dash;
