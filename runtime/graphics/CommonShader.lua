local Shader = require("mapscene/display/Shader");
local Palette = require("graphics/Palette");

local CommonShader = Class("CommonShader", Shader);

CommonShader.init = function(self, entity)
	Shader.super.init(self, entity);
	self:setShaderResource(ASSETS:getShader("assets/shader/common.glsl"));
	self:setHighlightColor();
end

CommonShader.setHighlightColor = function(self, color)
	-- TODO use https://love2d.org/wiki/Shader:sendColor
	-- And enable gamma correct rendering
	if color then
		self:setUniform("highlightColor", color);
	else
		self:setUniform("highlightColor", Palette.black);
	end
end

return CommonShader;
