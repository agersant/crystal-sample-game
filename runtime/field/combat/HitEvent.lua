local HitEvent = Class("HitEvent", crystal.Event);

HitEvent.init = function(self, entity, targetEntity)
	HitEvent.super.init(self, entity);
	assert(targetEntity);
	self._targetEntity = targetEntity;
end

HitEvent.getTargetEntity = function(self)
	return self._targetEntity;
end

return HitEvent;
