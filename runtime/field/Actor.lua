local Actor = Class("Actor", crystal.Behavior);

Actor.init = function(self, entity)
	Actor.super.init(self, entity, nil);
	assert(self._script);
	self._actionThread = nil;
end

Actor.isIdle = function(self)
	return not self._actionThread or self._actionThread:is_dead();
end

Actor.doAction = function(self, actionFunction)
	assert(self:isIdle());
	self._actionThread = self._script:run_thread(function(script)
		actionFunction(script);
		self._actionThread = nil;
		self:entity():signal_all_scripts("idle");
	end);
	return self._actionThread;
end

Actor.stopAction = function(self)
	if self:isIdle() then
		return;
	end
	self._actionThread:stop();
	self._actionThread = nil;
end

--#region Tests

crystal.test.add("Is idle after completing action", function()
	local world = crystal.World:new("test-data/empty.lua");

	local entity = world:spawn(crystal.Entity);
	entity:add_component(crystal.ScriptRunner);
	entity:add_component(Actor);

	assert(entity:isIdle());
	world:update(0);
	assert(entity:isIdle());

	entity:doAction(function(self)
		self:wait_for("s1");
	end);
	assert(not entity:isIdle());
	world:update(0);
	assert(not entity:isIdle());

	entity:signal_all_scripts("s1");
	assert(entity:isIdle());
end);

crystal.test.add("Can stop action", function()
	local world = crystal.World:new("test-data/empty.lua");

	local entity = world:spawn(crystal.Entity);
	entity:add_component(crystal.ScriptRunner);
	entity:add_component(Actor);

	local sentinel = false;

	world:update(0);
	entity:doAction(function(self)
		self:wait_for("s1");
		sentinel = true;
	end);
	assert(not entity:isIdle());
	entity:stopAction();
	assert(entity:isIdle());

	entity:signal_all_scripts("s1");
	assert(not sentinel);
end);

--#endregion

return Actor;
