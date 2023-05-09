local Skill = Class("Skill", crystal.Behavior);

Skill.init = function(self, skillSlot, scriptContent)
	assert(skillSlot);
	assert(scriptContent);
	Skill.super.init(self, scriptContent);

	local input_on = "+useSkill" .. skillSlot;
	local input_off = "-useSkill" .. skillSlot;

	self:script():add_thread(function(self)
		self:defer(self:add_input_handler(function(input)
			if input == input_on or input == input_off then
				self:signal(input);
				return true;
			end
		end));
		self:hang();
	end);

	self:script():add_thread(function(self)
		while true do
			self:wait_for(input_on);
			self:signal("+useSkill");
		end
	end);

	self:script():add_thread(function(self)
		while true do
			self:wait_for(input_off);
			self:signal("-useSkill");
		end
	end);
end

return Skill;
