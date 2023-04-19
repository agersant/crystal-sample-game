local Overlay = require("ui/bricks/elements/Overlay");
local Text = require("ui/bricks/elements/Text");
local Widget = require("ui/bricks/elements/Widget");
local Palette = require("graphics/Palette");

local HitWidget = Class("HitWidget", Widget);

HitWidget.init = function(self, amount)
	HitWidget.super.init(self);
	assert(amount);

	local overlay = self:setRoot(Overlay:new());

	local outline = overlay:add_child(Text:new());
	outline:setFont(crystal.ui.font("small"));
	outline:set_color(crystal.Color.black);
	outline:setTextAlignment("center");
	outline:setContent(amount);
	outline:set_padding_left(1);
	outline:set_padding_top(1);

	self._textWidget = overlay:add_child(Text:new());
	self._textWidget:setFont(crystal.ui.font("small"));
	self._textWidget:set_color(Palette.barbadosCherry);
	self._textWidget:setTextAlignment("center");
	self._textWidget:setContent(amount);
end

HitWidget.animate = function(self)
	local widget = self;
	self:script():signal("animate");
	return self:script():add_thread(function(self)
		self:stop_on("animate");
		self:tween(0, -8 + 16 * math.random(), .6, math.ease_linear, widget.set_translation_x, widget);
		self:wait_tween(0, -15, .2, math.ease_out_quadratic, widget.set_translation_y, widget);
		self:wait_tween(-15, 0, .4, math.ease_out_bounce, widget.set_translation_y, widget);
		self:wait(0.5);
		local shrink = self:tween(1, 0, 0.2, math.ease_in_quadratic, widget.set_scale_x, widget);
		local flyOut = self:tween(0, -15, 0.2, math.ease_in_quartic, widget.set_translation_y, widget);
		flyOut:block();
		shrink:block();
	end);
end

return HitWidget;
