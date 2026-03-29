local TitleScreenWidget = Class("TitleScreenWidget", crystal.Widget);

TitleScreenWidget.init = function(self)
	TitleScreenWidget.super.init(self);
	local overlay = self:set_child(crystal.Overlay:new());
	local text = overlay:add_child(crystal.Text:new());
	text:set_text("Project Golden Trout");
	text:set_alignment("center", "center");
end

local TitleScreen = Class("TitleScreen", crystal.Scene);

TitleScreen.init = function(self)
	self.widget = TitleScreenWidget:new();
end

TitleScreen.update = function(self, dt)
	local width, height = crystal.window.viewport_size();
	self.widget:update_tree(dt, width, height);
end

TitleScreen.key_pressed = function(self, key, scan_code, is_repeat)
	if key == "return" or key == "space" then
		crystal.scene.replace(Class:by_name("Arena"):new());
	end
end

TitleScreen.draw = function(self)
	self.widget:draw_tree();
end

return TitleScreen;
