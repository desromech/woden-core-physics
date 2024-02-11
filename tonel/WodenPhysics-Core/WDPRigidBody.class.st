"
I am a rigid body that lives in a physics world.
"
Class {
	#name : #WDPRigidBody,
	#superclass : #WDPCollisionObject,
	#instVars : [
		'mass',
		'inverseMass'
	],
	#category : #'WodenPhysics-Core-CollisionObjects'
}

{ #category : #update }
WDPRigidBody >> applyLinearImpulse: impulse [
	linearVelocity := linearVelocity + (impulse*inverseMass)
]

{ #category : #initialization }
WDPRigidBody >> initialize [
	super initialize.
	mass := inverseMass := 0.0.
]

{ #category : #update }
WDPRigidBody >> integrateMovementWithDeltaTime: deltaTime [
	| linearAcceleration |
	mass isZero ifTrue: [ ^ self ].
	
	linearAcceleration := owner gravity.
	self position:
		self position + (linearVelocity *deltaTime) + (linearAcceleration *(deltaTime*deltaTime*0.5)).
	linearVelocity := linearVelocity + (linearAcceleration*deltaTime).

]

{ #category : #accessing }
WDPRigidBody >> inverseMass [

	^ inverseMass
]

{ #category : #accessing }
WDPRigidBody >> mass [

	^ mass
]

{ #category : #accessing }
WDPRigidBody >> mass: aNumber [
	mass := aNumber.
	inverseMass := aNumber = 0 ifTrue: [ 0 ] ifFalse: [ aNumber reciprocal ].
]

{ #category : #testing }
WDPRigidBody >> needsCollisionDetection [
	^ mass ~= 0
]
