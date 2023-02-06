local CombatData = require("arpg/field/combat/CombatData");
local CombatHitbox = require("arpg/field/combat/CombatHitbox");
local DamageIntent = require("arpg/field/combat/damage/DamageIntent");
local Flinch = require("arpg/field/combat/hit-reactions/Flinch");
local HitBlink = require("arpg/field/combat/hit-reactions/HitBlink");
local FlinchAnimation = require("arpg/field/animation/FlinchAnimation");
local IdleAnimation = require("arpg/field/animation/IdleAnimation");
local WalkAnimation = require("arpg/field/animation/WalkAnimation");
local CommonShader = require("arpg/graphics/CommonShader");
local ComboAttack = require("arpg/content/job/warrior/ComboAttack");
local Dash = require("arpg/content/job/warrior/Dash");
local Actor = require("mapscene/behavior/Actor");
local ScriptRunner = require("mapscene/behavior/ScriptRunner");
local Sprite = require("mapscene/display/Sprite");
local SpriteAnimator = require("mapscene/display/SpriteAnimator");
local Locomotion = require("mapscene/physics/Locomotion");
local Collision = require("mapscene/physics/Collision");
local PhysicsBody = require("mapscene/physics/PhysicsBody");
local Weakbox = require("mapscene/physics/Weakbox");
local Entity = require("ecs/Entity");
local Script = require("script/Script");

local Warrior = Class("Warrior", Entity);

local hitReactions = function(self)
	while true do
		self:waitFor("died");
		self:stopAction();
		self:doAction(function(self)
			self:setAnimation("death");
			self:hang();
		end);
	end
end

Warrior.init = function(self, scene)
	Warrior.super.init(self, scene);

	local sheet = ASSETS:getSpritesheet("arpg/assets/spritesheet/duran.lua");
	local sprite = self:addComponent(Sprite:new());
	self:addComponent(SpriteAnimator:new(sprite, sheet));
	self:addComponent(CommonShader:new());
	self:addComponent(FlinchAnimation:new("knockback"));
	self:addComponent(IdleAnimation:new("idle"));
	self:addComponent(WalkAnimation:new("walk"));

	self:addComponent(ScriptRunner:new());
	self:addComponent(Actor:new());

	local physicsBody = self:addComponent(PhysicsBody:new(scene:getPhysicsWorld(), "dynamic"));
	self:addComponent(Locomotion:new());
	self:addComponent(Collision:new(physicsBody, 6));

	self:addComponent(CombatData:new());
	self:addComponent(DamageIntent:new());
	self:addComponent(CombatHitbox:new(physicsBody));
	self:addComponent(Weakbox:new(physicsBody));

	self:addComponent(HitBlink:new());
	self:addComponent(Flinch:new());

	self:addComponent(ComboAttack:new(1));
	self:addComponent(Dash:new(2));

	self:addScript(Script:new(hitReactions));
end

return Warrior;
