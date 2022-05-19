"
I am a rigid body that lives in a physics world.
"
Class {
	#name : #WDRigidBody,
	#superclass : #WDCollisionObject,
	#instVars : [
		'mass',
		'inverseMass'
	],
	#category : #'WodenPhysics-Core-RigidBody'
}

{ #category : #'as yet unclassified' }
WDRigidBody >> applyImpulse: impulse [
	linearVelocity := linearVelocity + (impulse*inverseMass)
]

{ #category : #initialization }
WDRigidBody >> initialize [
	super initialize.
	mass := inverseMass := 0.0.
]

{ #category : #update }
WDRigidBody >> integrateMovementWithDeltaTime: deltaTime [
	| linearAcceleration |
	mass isZero ifTrue: [ ^ self ].
	
	linearAcceleration := owner gravity.
	self position:
		self position + (linearVelocity *deltaTime) + (linearAcceleration *(deltaTime*deltaTime*0.5)).
	linearVelocity := linearVelocity + (linearAcceleration*deltaTime).

]

{ #category : #accessing }
WDRigidBody >> inverseMass [

	^ inverseMass
]

{ #category : #accessing }
WDRigidBody >> mass [

	^ mass
]

{ #category : #accessing }
WDRigidBody >> mass: aNumber [
	mass := aNumber.
	inverseMass := aNumber = 0 ifTrue: [ 0 ] ifFalse: [ aNumber reciprocal ].
]

{ #category : #testing }
WDRigidBody >> needsCollisionDetection [
	^ mass ~= 0
]
