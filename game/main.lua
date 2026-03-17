require("crystal");

love.graphics.setDefaultFilter("nearest", "nearest");

crystal.assets.set_directories({ "assets/", "test-data/" });
crystal.assets.load("assets/", "preload_whole_game")

crystal.window.set_native_height(240);
crystal.window.set_aspect_ratio_limits(4 / 3, 21 / 9);
crystal.window.set_scaling_mode("pixel_perfect");

crystal.physics.define_categories({ "player", "enemy" });

crystal.input.set_bindings(1, {
	-- Keyboard
	left = { "move_left", "ui_left" },
	right = { "move_right", "ui_right" },
	up = { "move_up", "ui_up" },
	down = { "move_down", "ui_down" },
	-- Gamepad
	dpleft = { "move_left", "ui_left" },
	dpright = { "move_right", "ui_right" },
	dpup = { "move_up", "ui_up" },
	dpdown = { "move_down", "ui_down" },
	leftx = { "move_x", "ui_x" },
	lefty = { "move_y", "ui_y" },
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
