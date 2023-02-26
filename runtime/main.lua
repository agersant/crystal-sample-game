love.filesystem.setIdentity("crystal-sample-game");

crystal.configure({
	assetsDirectories = { "assets/", "test-data/" },
	mapDirectory = "assets/map/",
	mapSceneClass = "Field",
	saveDataClass = "SaveData",
});

local Fonts = require("resources/Fonts");
FONTS = Fonts:new({
	small = "assets/font/16bfZX.ttf",
	body = "assets/font/karen2black.ttf",
	fat = "assets/font/karenfat.ttf",
});

crystal.input.player(1):set_bindings({
	-- Keyboard
	left = { "moveLeft" },
	right = { "moveRight" },
	up = { "moveUp" },
	down = { "moveDown" },
	q = { "interact", "useSkill1", "advanceDialog" },
	w = { "useSkill2" },
	e = { "useSkill3" },
	r = { "useSkill4" },
	-- Gamepad
	dpleft = { "moveLeft" },
	dpright = { "moveRight" },
	dpup = { "moveUp" },
	dpdown = { "moveDown" },
	leftx = { "moveX" },
	lefty = { "moveY" },
	pad_a = { "interact", "useSkill1", "advanceDialog" },
	pad_x = { "useSkill2" },
	pad_b = { "useSkill3" },
	pad_y = { "useSkill4" },
});

crystal.developer_start = function()
	crystal.cmd.run("loadmap dev2");
end
