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

INPUT:applyBindings({
	{
		left = { "moveLeft" },
		right = { "moveRight" },
		up = { "moveUp" },
		down = { "moveDown" },
		q = { "interact", "useSkill1", "advanceDialog" },
		w = { "useSkill2" },
		e = { "useSkill3" },
		r = { "useSkill4" },
	},
});
