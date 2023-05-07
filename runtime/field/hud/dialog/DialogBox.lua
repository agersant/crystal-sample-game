local Palette = require("graphics/Palette");

local DialogBox = Class("DialogBox", crystal.Widget);

DialogBox.init = function(self)
	DialogBox.super.init(self);
	self._textSpeed = 25;
	self._owner = nil;
	self._player = nil;

	self:set_opacity(0);

	local overlay = self:set_child(crystal.Overlay:new());

	local rc = overlay:add_child(crystal.RoundedCorners:new());
	rc:set_radius(8);
	rc:set_horizontal_alignment("stretch");

	local background = rc:set_child(crystal.Image:new());
	background:set_color(Palette.black6C);
	background:set_opacity(.8);
	background:set_image_size(1, 80);

	self._textWidget = overlay:add_child(crystal.Text:new());
	self._textWidget:set_font("body");
	self._textWidget:set_padding(8);
	self._textWidget:set_alignment("stretch", "stretch");

	self:bind_input("+advanceDialog", "always", nil, function()
		if self._active then
			self:script():signal("fastForward");
			return true;
		end
	end);
end

DialogBox.set_text = function(self, text)
	self._textWidget:set_text(text);
end

DialogBox.open = function(self)
	if self._active then
		return false;
	end
	self._active = true;
	self:set_opacity(1);
	return true;
end

DialogBox.sayLine = function(self, targetText)
	assert(targetText);

	local duration = #targetText / self._textSpeed;

	self:script():stop_all_threads();
	return self:script():add_thread(function(self)
		self:thread(function(self)
			self:stop_on("fastForward");
			self:defer(function()
				self:set_text(targetText);
			end);
			self:set_text("");
			self:wait_tween(0, #targetText, duration, math.ease_linear, function(numGlyphs)
				local numGlyphs = math.floor(numGlyphs);
				if numGlyphs > 1 then
					-- TODO: This assumes each glyph is one byte, not UTF-8 aware (so does the duration calculation above)
					self:set_text(string.sub(targetText, 1, numGlyphs));
				else
					self:set_text("");
				end
			end);
		end):block();
		self:wait_for("fastForward");
	end);
end

DialogBox.close = function(self)
	self._active = false;
	self:set_opacity(0);
end

return DialogBox;
