local DialogBox = require("field/hud/dialog/DialogBox");
local Overlay = require("ui/bricks/elements/Overlay");
local Widget = require("ui/bricks/elements/Widget");

local HUD = Class("HUD", Widget);

HUD.init = function(self)
	HUD.super.init(self);

	local overlay = self:setRoot(Overlay:new());

	self._dialogBox = overlay:add_child(DialogBox:new());
	self._dialogBox:set_padding_x(28);
	self._dialogBox:set_padding_bottom(8);
	self._dialogBox:set_alignment("stretch", "bottom");
end

HUD.getDialogBox = function(self)
	return self._dialogBox;
end

return HUD;
