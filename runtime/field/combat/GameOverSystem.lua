local CombatData = require("field/combat/CombatData");
local TitleScreen = require("frontend/TitleScreen");
local PartyMember = require("persistence/party/PartyMember");
local AllComponents = require("ecs/query/AllComponents");

local GameOverSystem = Class("GameOverSystem", crystal.System);

GameOverSystem.init = function(self, ecs)
	GameOverSystem.super.init(self, ecs);
	self._query = AllComponents:new({ CombatData, PartyMember });
	self:ecs():add_query(self._query);
end

GameOverSystem.afterScripts = function(self)
	local entities = self._query:getEntities();
	for entity in pairs(entities) do
		local combatData = entity:component(CombatData);
		if not combatData:isDead() then
			return;
		end
	end
	ENGINE:loadScene(TitleScreen:new());
end

return GameOverSystem;
