local DamageEvent = Class("DamageEvent", crystal.Event);

DamageEvent.init = function(self, attacker, damage, onHitEffects)
	assert(damage);
	assert(onHitEffects);
	self._attacker = attacker;
	self._damage = damage;
	self._onHitEffects = onHitEffects;
end

DamageEvent.getAttacker = function(self)
	return self._attacker;
end

DamageEvent.getDamage = function(self)
	return self._damage;
end

DamageEvent.getOnHitEffects = function(self)
	return self._onHitEffects;
end

return DamageEvent;
