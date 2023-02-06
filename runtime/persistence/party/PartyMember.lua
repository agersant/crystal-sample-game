local Component = require("ecs/Component");

local PartyMember = Class("PartyMember", Component);

PartyMember.init = function(self)
	PartyMember.super.init(self);
end

return PartyMember;
