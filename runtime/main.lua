love.filesystem.setIdentity("crystal-sample-game");
love.graphics.setDefaultFilter("nearest", "nearest");
love.window.setTitle("Crystal Sample Game");
love.window.setMode(1280, 720, {
	msaa = 8,
	resizable = true,
	vsync = false,
});

crystal.configure({
	assetsDirectories = { "assets/", "test-data/" },
	physics_categories = { "solid", "trigger", "hitbox", "weakbox" },
});

crystal.window.set_native_height(240);
crystal.window.set_aspect_ratio_limits(4 / 3, 21 / 9);

crystal.ui.register_font("small", love.graphics.newFont("assets/font/16bfZX.ttf", 16));
crystal.ui.register_font("body", love.graphics.newFont("assets/font/karen2black.ttf", 16));
crystal.ui.register_font("fat", love.graphics.newFont("assets/font/karenfat.ttf", 16));

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
		uiLeft = { pressed_range = { -1.0, -0.9 }, stickiness = 0.7 },
		uiRight = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
	uiY = {
		uiUp = { pressed_range = { -1.0, -0.9 }, stickiness = 0.7 },
		uiDown = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
});

crystal.developer_start = function()
	crystal.cmd.run("loadmap dev2");
end
