local DialogBox = require("field/hud/dialog/DialogBox");

local HUD = Class("HUD", crystal.Widget);

HUD.init = function(self)
	HUD.super.init(self);

	local overlay = self:set_root(crystal.Overlay:new());

	self._dialogBox = overlay:add_child(DialogBox:new());
	self._dialogBox:set_padding_x(28);
	self._dialogBox:set_padding_bottom(8);
	self._dialogBox:set_alignment("stretch", "bottom");
end

HUD.getDialogBox = function(self)
	return self._dialogBox;
end

return HUD;
