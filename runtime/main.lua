love.filesystem.setIdentity("crystal-sample-game");

crystal.configure({
	assetsDirectories = { "assets/", "test-data/" },
	physicsCategories = { "solid", "trigger", "hitbox", "weakbox" },
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
	left = { "moveLeft", "uiLeft" },
	right = { "moveRight", "uiRight" },
	up = { "moveUp", "uiUp" },
	down = { "moveDown", "uiDown" },
	q = { "interact", "useSkill1", "advanceDialog" },
	w = { "useSkill2" },
	e = { "useSkill3" },
	r = { "useSkill4" },
	-- Gamepad
	dpleft = { "moveLeft", "uiLeft" },
	dpright = { "moveRight", "uiRight" },
	dpup = { "moveUp", "uiUp" },
	dpdown = { "moveDown", "uiDown" },
	leftx = { "moveX", "uiX" },
	lefty = { "moveY", "uiY" },
	btna = { "interact", "useSkill1", "advanceDialog" },
	btnx = { "useSkill2" },
	btnb = { "useSkill3" },
	btny = { "useSkill4" },
});

crystal.input.configure_autorepeat({
	uiLeft = { initial_delay = 0.5, period = 0.1 },
	uiRight = { initial_delay = 0.5, period = 0.1 },
	uiUp = { initial_delay = 0.5, period = 0.1 },
	uiDown = { initial_delay = 0.5, period = 0.1 },
});

crystal.input.map_axis_to_actions({
	uiX = {
		uiLeft = { pressed_range = { -1.0, -0.9 }, released_range = { -0.2, 1.0 } },
		uiRight = { pressed_range = { 0.9, 1.0 }, released_range = { -1.0, 0.2 } },
	},
	uiY = {
		uiUp = { pressed_range = { -1.0, -0.9 }, released_range = { -0.2, 1.0 } },
		uiDown = { pressed_range = { 0.9, 1.0 }, released_range = { -1.0, 0.2 } },
	},
});

crystal.developer_start = function()
	crystal.cmd.run("loadmap dev2");
end
