local PartyMemberData = require("persistence/party/PartyMemberData");
local TableUtils = require("utils/TableUtils");

local PartyData = Class("PartyData");

PartyData.init = function(self)
	self._members = {};
end

PartyData.addMember = function(self, member)
	assert(not TableUtils.contains(self._members, member));
	table.insert(self._members, member);
end

PartyData.removeMember = function(self, member)
	assert(TableUtils.contains(self._members, member));
	for i, partyMember in ipairs(self._members) do
		if partyMember == member then
			table.remove(self._members, i);
		end
	end
end

PartyData.getMembers = function(self)
	return TableUtils.shallowCopy(self._members);
end

PartyData.toPOD = function(self)
	local pod = {};
	pod.members = {};
	for i, partyMember in ipairs(self._members) do
		table.insert(pod.members, partyMember:toPOD());
	end
	return pod;
end

PartyData.fromPOD = function(self, pod)
	local party = PartyData:new();
	assert(pod.members);
	for i, memberPOD in ipairs(pod.members) do
		local member = PartyMemberData:fromPOD(memberPOD);
		party:addMember(member);
	end
	return party;
end

--#region Tests

crystal.test.add("Add member", function()
	local party = PartyData:new();
	local member = PartyMemberData:new("Thief");
	party:addMember(member);
	assert(#party:getMembers() == 1);
	assert(party:getMembers()[1] == member);
end);

crystal.test.add("Remove member", function()
	local party = PartyData:new();
	local member = PartyMemberData:new("Thief");
	party:addMember(member);
	party:removeMember(member);
	assert(#party:getMembers() == 0);
end);

crystal.test.add("Save and load", function()
	local original = PartyData:new();
	local member = PartyMemberData:new("Thief");
	original:addMember(member);
	local copy = PartyData:fromPOD(original:toPOD());
	assert(#copy:getMembers() == 1);
	assert(copy:getMembers()[1]:getInstanceClass() == original:getMembers()[1]:getInstanceClass());
	assert(copy:getMembers()[1]:getAssignedPlayer() == original:getMembers()[1]:getAssignedPlayer());
end);

--#endregion

return PartyData;
