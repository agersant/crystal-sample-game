local DialogBox = require("field/hud/dialog/DialogBox");
local Overlay = require("ui/bricks/elements/Overlay");
local Widget = require("ui/bricks/elements/Widget");

local HUD = Class("HUD", Widget);

HUD.init = function(self)
	HUD.super.init(self);

	local overlay = self:setRoot(Overlay:new());

	self._dialogBox = overlay:addChild(DialogBox:new());
	self._dialogBox:setLeftPadding(28);
	self._dialogBox:setRightPadding(28);
	self._dialogBox:setBottomPadding(8);
	self._dialogBox:setHorizontalAlignment("stretch");
	self._dialogBox:setVerticalAlignment("bottom");
end

HUD.getDialogBox = function(self)
	return self._dialogBox;
end

return HUD;
