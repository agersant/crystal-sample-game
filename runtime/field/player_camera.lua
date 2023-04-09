---@class PlayerCamera : Camera
---@field private player Entity
---@field private x number
---@field private y number
local PlayerCamera = Class("PlayerCamera", crystal.Camera);

PlayerCamera.init = function(self, player)
	self.player = player;
	local x, y = player:position();
	self.x = x;
	self.y = y;
end

---@return number
---@return number
PlayerCamera.position = function(self)
	local player_x, player_y = self.player:position();
	self.x = math.clamp(self.x, player_x - 32, player_x + 32);
	self.y = math.clamp(self.y, player_y - 32, player_y + 32);

	local map_width, map_height = map:pixel_size();
	local viewport_width, viewport_height = crystal.window.viewport_size();

	if map_width < viewport_width then
		self.x = map_width / 2;
	else
		self.x = math.clamp(self.x, viewport_width / 2, map_width - viewport_width / 2);
	end

	if map_height < viewport_height then
		self.y = map_height / 2;
	else
		self.y = math.clamp(self.y, viewport_height / 2, map_height - viewport_height / 2);
	end

	return self.x, self.y;
end

return PlayerCamera;
