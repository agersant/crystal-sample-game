require("crystal/runtime");

love.graphics.setDefaultFilter("nearest", "nearest");

crystal.assets.set_directories({ "assets/", "test-data/" });

crystal.window.set_native_height(240);
crystal.window.set_aspect_ratio_limits(4 / 3, 21 / 9);

crystal.physics.define_categories({ "solid", "trigger", "hitbox", "weakbox" });

crystal.ui.register_font("small", love.graphics.newFont("assets/font/16bfZX.ttf", 16));
crystal.ui.register_font("body", love.graphics.newFont("assets/font/karen2black.ttf", 16));
crystal.ui.register_font("fat", love.graphics.newFont("assets/font/karenfat.ttf", 16));

crystal.input.player(1):set_bindings({
	-- Keyboard
	left = { "moveLeft", "ui_left" },
	right = { "moveRight", "ui_right" },
	up = { "moveUp", "ui_up" },
	down = { "moveDown", "ui_down" },
	q = { "interact", "useSkill1", "advanceDialog" },
	w = { "useSkill2" },
	e = { "useSkill3" },
	r = { "useSkill4" },
	-- Gamepad
	dpleft = { "moveLeft", "ui_left" },
	dpright = { "moveRight", "ui_right" },
	dpup = { "moveUp", "ui_up" },
	dpdown = { "moveDown", "ui_down" },
	leftx = { "moveX", "ui_x" },
	lefty = { "moveY", "ui_y" },
	btna = { "interact", "useSkill1", "advanceDialog" },
	btnx = { "useSkill2" },
	btnb = { "useSkill3" },
	btny = { "useSkill4" },
});

crystal.input.configure_autorepeat({
	ui_left = { initial_delay = 0.5, period = 0.1 },
	ui_right = { initial_delay = 0.5, period = 0.1 },
	ui_up = { initial_delay = 0.5, period = 0.1 },
	ui_down = { initial_delay = 0.5, period = 0.1 },
});

crystal.input.map_axis_to_actions({
	ui_x = {
		ui_left = { pressed_range = { -1.0, -0.9 }, stickiness = 0.7 },
		ui_up = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
	ui_y = {
		uiUp = { pressed_range = { -1.0, -0.9 }, stickiness = 0.7 },
		ui_down = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
});

crystal.player_start = function()
	crystal.cmd.run("loadscene TitleScreen");
end

crystal.developer_start = function()
	crystal.cmd.run("loadmap dev2");
end
