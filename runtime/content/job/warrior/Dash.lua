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

	self:defer(self:disableLocomotion());

	self:resetMultiHitTracking();
	local onHitEffects = { FlinchEffect:new(FlinchAmounts.LARGE) };
	self:setDamagePayload({ DamageUnit:new(10) }, onHitEffects);

	self:setAnimation("dash", self:getAngle4());

	local angle = self:getAngle();
	local dx = math.cos(angle);
	local dy = math.sin(angle);

	self:wait_tween(buildupPeakSpeed, 0, buildupDuration, "outCubic", function(speed)
		self:setLinearVelocity( -dx * speed, -dy * speed);
	end);
	self:wait_tween(peakSpeed, recoveryBeginSpeed, dashDuration, "outQuartic", function(speed)
		self:setLinearVelocity(dx * speed, dy * speed);
	end);
	self:wait_tween(recoveryBeginSpeed, 0, recoveryDuration, "outQuadratic", function(speed)
		self:setLinearVelocity(dx * speed, dy * speed);
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
