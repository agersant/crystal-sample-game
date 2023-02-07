love.conf = function(options)
	options.console = not love.filesystem.isFused();
	options.window = false;
	options.modules.touch = false;
	options.modules.video = false;
	options.modules.thread = false;
end
