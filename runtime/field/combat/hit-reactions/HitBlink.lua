local Palette = require("graphics/Palette");

local HitBlink = Class("HitBlink", crystal.Behavior);

local script = function(self)
	while true do
		self:wait_for("receivedDamage");
		self:setHighlightColor(Palette.strawberry);
		self:wait(2 * 1 / 60);
		self:setHighlightColor(Palette.cyan);
		self:wait(2 * 1 / 60);
		self:setHighlightColor(nil);
		self:wait(2 * 1 / 60);
		self:wait_tween(1, 0, 0.3, math.ease_in_cubic, function(t)
			local c = Palette.strawberry;
			self:setHighlightColor({ c[1] * t, c[2] * t, c[3] * t });
		end);
		self:setHighlightColor(nil);
	end
end

HitBlink.init = function(self)
	HitBlink.super.init(self, script);
end

return HitBlink;
