love.conf = function(t)
	t.console = not love.filesystem.isFused();
	t.modules.touch = false;
	t.modules.video = false;

	t.identity = "crystal-sample-game";

	t.window.title = "Crystal Sample Game";
	t.window.width = 1280;
	t.window.height = 720;
	t.window.resizable = true;
	t.window.vsync = true;
	t.window.msaa = 8;
end
