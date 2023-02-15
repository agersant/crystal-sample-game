local Teams = Class("Teams");

Teams.party = 0;
Teams.wild = 1;

Teams.is_valid = function(self, team)
	return team == Teams.party or team == Teams.wild;
end

Teams.areAllies = function(self, teamA, teamB)
	assert(Teams:is_valid(teamA));
	assert(Teams:is_valid(teamB));
	return teamA == teamB;
end

Teams.areEnemies = function(self, teamA, teamB)
	assert(Teams:is_valid(teamA));
	assert(Teams:is_valid(teamB));
	return teamA ~= teamB;
end

return Teams;
