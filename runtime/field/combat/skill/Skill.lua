local Skill = Class("Skill", crystal.Behavior);

Skill.init = function(self, skillSlot, scriptContent)
	assert(skillSlot);
	assert(scriptContent);
	Skill.super.init(self, scriptContent);

	local command = "useSkill" .. skillSlot

	self._script:add_thread(function(self)
		while true do
			self:wait_for("+" .. command);
			self:signal("+useSkill");
		end
	end);

	self._script:add_thread(function(self)
		while true do
			self:wait_for("-" .. command);
			self:signal("-useSkill");
		end
	end);
end

return Skill;
