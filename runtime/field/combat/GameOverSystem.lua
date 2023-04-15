local CombatData = require("field/combat/CombatData");
local TitleScreen = require("frontend/TitleScreen");

local GameOverSystem = Class("GameOverSystem", crystal.System);

GameOverSystem.init = function(self)
	self._query = self:add_query({ CombatData, "PartyMember" });
end

GameOverSystem.update = function(self)
	local entities = self._query:entities();
	for entity in pairs(entities) do
		local combatData = entity:component(CombatData);
		if not combatData:isDead() then
			return;
		end
	end
	crystal.scene.replace(TitleScreen:new());
end

return GameOverSystem;
