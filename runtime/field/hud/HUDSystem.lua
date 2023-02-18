local HUD = require("field/hud/HUD");

local HUDSystem = Class("HUDSystem", crystal.System);

HUDSystem.init = function(self, viewport)
	assert(viewport);
	self._viewport = viewport;
	self._hud = HUD:new();
end

HUDSystem.getHUD = function(self)
	return self._hud;
end

HUDSystem.afterScripts = function(self, dt)
	local width, height = self._viewport:getRenderSize();
	self._hud:updateTree(dt, width, height);
end

HUDSystem.drawOverlay = function(self)
	self._hud:draw();
end

return HUDSystem;
