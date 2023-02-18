local IdleAnimation = Class("IdleAnimation", crystal.Component);

IdleAnimation.init = function(self, animationName)
	self._animationName = animationName;
end

IdleAnimation.getIdleAnimation = function(self)
	return self._animationName;
end

IdleAnimation.setIdleAnimation = function(self, animationName)
	self._animationName = animationName;
end

return IdleAnimation;
