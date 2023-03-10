local WalkAnimation = Class("WalkAnimation", crystal.Component);

WalkAnimation.init = function(self, animationName)
	self._animationName = animationName;
end

WalkAnimation.getWalkAnimation = function(self)
	return self._animationName;
end

WalkAnimation.setWalkAnimation = function(self, animationName)
	self._animationName = animationName;
end

return WalkAnimation;
