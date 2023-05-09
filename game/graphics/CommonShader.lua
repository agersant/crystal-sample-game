---@class CommonShader : DrawEffect
local CommonShader = Class("CommonShader", crystal.DrawEffect);

CommonShader.init = function(self)
	self.shader = crystal.assets.get("assets/shader/common.glsl");
	self.highlight_color = crystal.Color.black;
end

---@param color? crystal.Color
CommonShader.set_highlight_color = function(self, color)
	self.highlight_color = color or crystal.Color.black;
end

CommonShader.pre_draw = function(self)
	self.shader:sendColor("highlightColor", self.highlight_color);
	love.graphics.setShader(self.shader);
end

return CommonShader;
