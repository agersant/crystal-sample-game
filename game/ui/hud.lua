local HUD = Class("HUD", crystal.Widget);

HUD.init = function(self)
	HUD.super.init(self);
    self.overlay = self:set_child(crystal.Overlay:new());
end

HUD.add_hud_widget = function(self, widget)
    self.overlay:add_child(widget);
    return widget;
end

local HUDSystem = Class("HUDSystem", crystal.System);

HUDSystem.init = function(self)
	self._hud = HUD:new();
end

HUDSystem.getHUD = function(self)
	return self._hud;
end

HUDSystem.update = function(self, dt)
	local width, height = crystal.window.viewport_size();
	self._hud:update_tree(dt, width, height);
end

HUDSystem.action_pressed = function(self, player_index, action)
	return self._hud:action_pressed(player_index, action);
end

HUDSystem.action_released = function(self, player_index, action)
	return self._hud:action_released(player_index, action);
end

HUDSystem.draw_ui = function(self)
	self._hud:draw_tree();
end
