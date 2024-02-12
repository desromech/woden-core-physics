"
I am a rigid body that lives in a physics world.
"
Class {
	#name : #WDPRigidBody,
	#superclass : #WDPCollisionObject,
	#instVars : [
		'mass',
		'inverseMass',
		'linearDamping',
		'angularDamping'
	],
	#category : #'WodenPhysics-Core-CollisionObjects'
}

{ #category : #'as yet unclassified' }
WDPRigidBody class >> defaultAngularDamping [
	^ 0.01
]

{ #category : #'as yet unclassified' }
WDPRigidBody class >> defaultLinearDamping [
	^ 0.01
]

{ #category : #accessing }
WDPRigidBody >> angularDamping [

	^ angularDamping
]

{ #category : #accessing }
WDPRigidBody >> angularDamping: anObject [

	angularDamping := anObject
]

{ #category : #update }
WDPRigidBody >> applyLinearImpulse: impulse [
	linearVelocity := linearVelocity + (impulse*inverseMass)
]

{ #category : #initialization }
WDPRigidBody >> initialize [
	super initialize.
	mass := inverseMass := 0.0.
	linearDamping := self class defaultLinearDamping.
	angularDamping := self class defaultAngularDamping.
]

{ #category : #update }
WDPRigidBody >> integrateMovementWithDeltaTime: deltaTime [
	| linearAcceleration integratedPosition integratedOrientation angularAcceleration |
	mass isZero ifTrue: [ ^ self ].
	
	linearAcceleration := owner gravity + (linearVelocity * linearDamping negated ).
	linearVelocity := linearVelocity + (linearAcceleration*deltaTime).
	integratedPosition := self position + (linearVelocity *deltaTime).

	angularAcceleration := angularVelocity * angularDamping negated.
	angularVelocity := angularVelocity + (angularAcceleration*deltaTime).

	integratedOrientation := self orientation + ((Quaternion xyz: angularVelocity * 0.5 *deltaTime) * self orientation).
	integratedOrientation := integratedOrientation normalized.
	self position: integratedPosition orientation: integratedOrientation.

]

{ #category : #accessing }
WDPRigidBody >> inverseMass [

	^ inverseMass
]

{ #category : #accessing }
WDPRigidBody >> linearDamping [

	^ linearDamping
]

{ #category : #accessing }
WDPRigidBody >> linearDamping: anObject [

	linearDamping := anObject
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
