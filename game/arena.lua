local Arena = Class("Arena", crystal.Scene);

Arena.init = function(self)
    self.camera_controller = crystal.CameraController:new();
    self.camera_controller:cut_to(crystal.Camera:new());
end

Arena.update = function(self, dt)
end

Arena.draw = function(self)
    love.graphics.clear(10/255, 152/255, 172/255);
    local platform_image = crystal.assets.get("assets/platform.png");
    self.camera_controller:draw(function()
        love.graphics.draw(platform_image, -platform_image:getWidth()/2, -platform_image:getHeight()/2);
    end);
end

return Arena;
