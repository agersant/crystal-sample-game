local YDrawOrder = Class("YDrawOrder", crystal.DrawOrder);

YDrawOrder.draw_order = function(self)
	local x, y = self:entity():position();
	return y;
end
