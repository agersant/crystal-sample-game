-- TODO this file should not exist (same for Game base class)

local Game = require("Game");

local ARPG = Class("ARPG", Game);

ARPG.init = function(self)
	ARPG.super.init(self);
	self.classes.MapScene = require("field/Field");
	self.classes.SaveData = require("persistence/SaveData");
	self.sourceDirectories = { "arpg/content", "arpg/field", "arpg/frontend", "arpg/graphics", "arpg/persistence" };
	self.mapDirectory = "arpg/assets/map";
	self.testFiles = {
		"arpg/field/combat/ai/TestTargetSelector",
		"arpg/field/combat/TestCombatData",
		"arpg/persistence/party/TestPartyData",
		"arpg/persistence/party/TestPartyMemberData",
		"arpg/field/hud/dialog/TestDialog",
	};
	self.fonts = {
		small = "arpg/assets/font/16bfZX.ttf",
		body = "arpg/assets/font/karen2black.ttf",
		fat = "arpg/assets/font/karenfat.ttf",
	};
	self.defaultBindings = {
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
	};
end

return ARPG;
