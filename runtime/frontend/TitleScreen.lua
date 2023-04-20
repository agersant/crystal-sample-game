local Widget = require("ui/bricks/elements/Widget");

local TitleScreenWidget = Class("TitleScreenWidget", Widget);
local TitleScreen = Class("TitleScreen", crystal.Scene);

TitleScreenWidget.init = function(self)
	TitleScreenWidget.super.init(self);
	local overlay = self:setRoot(crystal.Overlay:new());
	local text = overlay:add_child(crystal.Text:new());
	text:set_font(crystal.ui.font("fat"));
	text:set_text("Project Crystal");
	text:set_alignment("center", "center");
end

TitleScreen.init = function(self)
	self.widget = TitleScreenWidget:new();
end

TitleScreen.update = function(self, dt)
	local width, height = crystal.window.viewport_size();
	self.widget:update_tree(dt, width, height);
end

TitleScreen.draw = function(self)
	self.widget:draw();
end

return TitleScreen;
