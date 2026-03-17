require("crystal");

love.graphics.setDefaultFilter("nearest", "nearest");

crystal.assets.set_directories({ "assets/", "test-data/" });
crystal.assets.load("assets/", "preload_whole_game")

crystal.window.set_native_height(240);
crystal.window.set_aspect_ratio_limits(4 / 3, 21 / 9);
crystal.window.set_scaling_mode("pixel_perfect");

crystal.input.set_bindings(1, {
	-- Keyboard
	left = { "moveLeft", "ui_left" },
	right = { "moveRight", "ui_right" },
	up = { "moveUp", "ui_up" },
	down = { "moveDown", "ui_down" },
	-- Gamepad
	dpleft = { "moveLeft", "ui_left" },
	dpright = { "moveRight", "ui_right" },
	dpup = { "moveUp", "ui_up" },
	dpdown = { "moveDown", "ui_down" },
	leftx = { "moveX", "ui_x" },
	lefty = { "moveY", "ui_y" },
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
		ui_right = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
	ui_y = {
		ui_up = { pressed_range = { -1.0, -0.9 }, stickiness = 0.7 },
		ui_down = { pressed_range = { 0.9, 1.0 }, stickiness = 0.7 },
	},
});

crystal.player_start = function()
	crystal.cmd.run("loadscene TitleScreen");
end

crystal.developer_start = function()
	crystal.cmd.run("loadscene Arena");
end
