local Overlay = require("ui/bricks/elements/Overlay");
local Text = require("ui/bricks/elements/Text");
local Widget = require("ui/bricks/elements/Widget");
local Palette = require("graphics/Palette");

local HitWidget = Class("HitWidget", Widget);

HitWidget.init = function(self, amount)
	HitWidget.super.init(self);
	assert(amount);

	local overlay = self:setRoot(Overlay:new());

	local outline = overlay:addChild(Text:new());
	outline:setFont(FONTS:get("small", 16));
	outline:setColor(Palette.black);
	outline:setTextAlignment("center");
	outline:setContent(amount);
	outline:setLeftPadding(1);
	outline:setTopPadding(1);

	self._textWidget = overlay:addChild(Text:new());
	self._textWidget:setFont(FONTS:get("small", 16));
	self._textWidget:setColor(Palette.barbadosCherry);
	self._textWidget:setTextAlignment("center");
	self._textWidget:setContent(amount);
end

HitWidget.animate = function(self)
	local widget = self;
	self:script():signal("animate");
	return self:script():add_thread(function(self)
		self:end_on("animate");
		self:tween(0, -8 + 16 * math.random(), .6, "linear", widget.setXTranslation, widget);
		self:wait_tween(0, -15, .2, "outQuadratic", widget.setYTranslation, widget);
		self:wait_tween( -15, 0, .4, "outBounce", widget.setYTranslation, widget);
		self:wait(0.5);
		local shrink = self:tween(1, 0, 0.2, "inQuadratic", widget.setXScale, widget);
		local flyOut = self:tween(0, -15, 0.2, "inQuartic", widget.setYTranslation, widget);
		self:join(flyOut);
		self:join(shrink);
	end);
end

return HitWidget;
