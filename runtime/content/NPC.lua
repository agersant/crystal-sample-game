local NPC = Class("NPC", crystal.Entity);

local npc_script = function(self)
	while true do
		local player = self:wait_for("interact");
		if self:beginDialog(player) then
			self:join(self:sayLine(
				"The harvest this year was meager, there is no spare bread for a stranger like you. If I cannot feed my children, why would I feed you? Extra lines of text to get to line four, come on just a little more."));
			self:join(self:sayLine("Now leave this town before things go awry, please."));
			self:endDialog();
		end
	end
end

NPC.init = function(self)
	local scene = self:ecs();
	local sheet = ASSETS:getSpritesheet("assets/spritesheet/sahagin.lua");
	local sprite = self:add_component("Sprite");
	self:add_component("SpriteAnimator", sprite, sheet);
	self:add_component("IdleAnimation", "idle");

	self:add_component(crystal.Body);
	local collider = self:add_component(crystal.Collider, love.physics.newCircleShape(4));
	collider:set_categories("solid");
	collider:enable_collision_with("solid");

	self:add_component("ScriptRunner");
	self:add_component("Dialog", scene:getHUD():getDialogBox());
	self:add_script(npc_script);
end

return NPC;
