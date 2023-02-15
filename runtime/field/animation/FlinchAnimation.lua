local FlinchAnimation = Class("FlinchAnimation", crystal.Component);

FlinchAnimation.init = function(self, entity, animationName)
	FlinchAnimation.super.init(self, entity);
	self._animationName = animationName;
end

FlinchAnimation.getFlinchAnimation = function(self)
	return self._animationName;
end

FlinchAnimation.setFlinchAnimation = function(self, animationName)
	self._animationName = animationName;
end

return FlinchAnimation;
