local Overlay = require("ui/bricks/elements/Overlay");
local Widget = require("ui/bricks/elements/Widget");
local Text = require("ui/bricks/elements/Text");

local TitleScreenWidget = Class("TitleScreenWidget", Widget);
local TitleScreen = Class("TitleScreen", crystal.Scene);

TitleScreenWidget.init = function(self)
	TitleScreenWidget.super.init(self);
	local overlay = self:setRoot(Overlay:new());
	local text = overlay:addChild(Text:new());
	text:setFont(FONTS:get("fat", 16));
	text:setContent("Project Crystal");
	text:setAlignment("center", "center");
end

TitleScreen.init = function(self)
	self.widget = TitleScreenWidget:new();
end

TitleScreen.update = function(self, dt)
	local width, height = crystal.window.viewport_size();
	self.widget:updateTree(dt, width, height);
end

TitleScreen.draw = function(self)
	self.widget:draw();
end

return TitleScreen;
