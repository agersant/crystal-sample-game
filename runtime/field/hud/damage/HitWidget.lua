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
	outline:setFont(crystal.ui.font("small"));
	outline:setColor(crystal.Color.black);
	outline:setTextAlignment("center");
	outline:setContent(amount);
	outline:setLeftPadding(1);
	outline:setTopPadding(1);

	self._textWidget = overlay:addChild(Text:new());
	self._textWidget:setFont(crystal.ui.font("small"));
	self._textWidget:setColor(Palette.barbadosCherry);
	self._textWidget:setTextAlignment("center");
	self._textWidget:setContent(amount);
end

HitWidget.animate = function(self)
	local widget = self;
	self:script():signal("animate");
	return self:script():add_thread(function(self)
		self:stop_on("animate");
		self:tween(0, -8 + 16 * math.random(), .6, math.ease_linear, widget.setXTranslation, widget);
		self:wait_tween(0, -15, .2, math.ease_out_quadratic, widget.setYTranslation, widget);
		self:wait_tween(-15, 0, .4, math.ease_out_bounce, widget.setYTranslation, widget);
		self:wait(0.5);
		local shrink = self:tween(1, 0, 0.2, math.ease_in_quadratic, widget.setXScale, widget);
		local flyOut = self:tween(0, -15, 0.2, math.ease_in_quartic, widget.setYTranslation, widget);
		self:join(flyOut);
		self:join(shrink);
	end);
end

return HitWidget;
