local PartyMember = require("persistence/party/PartyMember");

local PartyMemberData = Class("PartyMemberData");

PartyMemberData.init = function(self, instanceClass)
	self._instanceClass = instanceClass;
end

PartyMemberData.getInstanceClass = function(self)
	assert(self._instanceClass);
	return self._instanceClass;
end

PartyMemberData.getAssignedPlayer = function(self)
	return self._assignedPlayer;
end

PartyMemberData.setAssignedPlayer = function(self, assignedPlayer)
	self._assignedPlayer = assignedPlayer;
end

PartyMemberData.toPOD = function(self)
	return { instanceClass = self:getInstanceClass(), assignedPlayer = self:getAssignedPlayer() };
end

PartyMemberData.fromPOD = function(self, pod)
	assert(pod.instanceClass);
	local partyMemberData = PartyMemberData:new(pod.instanceClass);
	partyMemberData:setAssignedPlayer(pod.assignedPlayer);
	return partyMemberData;
end

PartyMemberData.fromEntity = function(self, entity)
	local className = entity:getClassName();
	assert(entity:component(PartyMember));
	local inputListener = entity:component(crystal.InputListener);

	local partyMemberData = PartyMemberData:new(className);
	if inputListener then
		PartyMemberData:setAssignedPlayer(inputListener:input_player():index());
	end
	return partyMemberData;
end

--#region Test

crystal.test.add("Instance class", function()
	local original = PartyMemberData:new("Sailor");
	assert(original:getInstanceClass() == "Sailor");
	local copy = PartyMemberData:fromPOD(original:toPOD());
	assert(copy:getInstanceClass() == original:getInstanceClass());
end);

crystal.test.add("Assigned player", function()
	local original = PartyMemberData:new("Sailor");
	original:setAssignedPlayer(2);
	assert(original:getAssignedPlayer() == 2);
	local copy = PartyMemberData:fromPOD(original:toPOD());
	assert(copy:getAssignedPlayer() == original:getAssignedPlayer());
end);

--#endregion

return PartyMemberData;
