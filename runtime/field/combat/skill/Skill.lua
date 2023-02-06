local Behavior = require("mapscene/behavior/Behavior");
local Script = require("script/Script");

local Skill = Class("Skill", Behavior);

Skill.init = function(self, skillSlot, scriptContent)
	assert(skillSlot);
	assert(scriptContent);
	Skill.super.init(self, scriptContent);

	local command = "useSkill" .. skillSlot

	self._script:addThread(function(self)
		while true do
			self:waitFor("+" .. command);
			self:signal("+useSkill");
		end
	end);

	self._script:addThread(function(self)
		while true do
			self:waitFor("-" .. command);
			self:signal("-useSkill");
		end
	end);
end

return Skill;
