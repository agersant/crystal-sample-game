require("crystal/runtime");

crystal.configure({
	assetsDirectory = "assets/"
});

love.filesystem.setIdentity("crystal-sample-game");
