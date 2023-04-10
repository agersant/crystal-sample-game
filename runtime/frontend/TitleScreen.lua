local Overlay = require("ui/bricks/elements/Overlay");
local Widget = require("ui/bricks/elements/Widget");
local Text = require("ui/bricks/elements/Text");

local TitleScreenWidget = Class("TitleScreenWidget", Widget);
local TitleScreen = Class("TitleScreen", crystal.UIScene);

TitleScreenWidget.init = function(self)
	TitleScreenWidget.super.init(self);

	local overlay = self:setRoot(Overlay:new());

	local text = overlay:addChild(Text:new());
	text:setFont(FONTS:get("fat", 16));
	text:setContent("Project Crystal");
	text:setAlignment("center", "center");
end

TitleScreen.init = function(self)
	TitleScreen.super.init(self, TitleScreenWidget:new());
end

return TitleScreen;
