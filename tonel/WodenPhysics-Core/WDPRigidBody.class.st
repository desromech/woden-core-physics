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
		'angularDamping',
		'inverseInertiaTensor',
		'inertiaTensor',
		'rotationMatrix',
		'worldInertiaTensor',
		'worldInverseInertiaTensor',
		'netForce',
		'netTorque'
	],
	#category : #'WodenPhysics-Core-CollisionObjects'
}

{ #category : #defaults }
WDPRigidBody class >> defaultAngularDamping [
	^ 0.2
]

{ #category : #defaults }
WDPRigidBody class >> defaultLinearDamping [
	^ 0.2
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
WDPRigidBody >> applyAngularImpulse: impulse [
	angularVelocity := angularVelocity + (worldInverseInertiaTensor * impulse)
]

{ #category : #update }
WDPRigidBody >> applyForce: force [
	netForce := netForce + force.
]

{ #category : #update }
WDPRigidBody >> applyImpulse: impulse inPosition: worldPosition [
	self applyImpulse: impulse inRelativePosition: worldPosition - self position
]

{ #category : #update }
WDPRigidBody >> applyImpulse: impulse inRelativePosition: relativePosition [
	self applyLinearImpulse: impulse.
	self applyAngularImpulse: (relativePosition cross: impulse).
]

{ #category : #update }
WDPRigidBody >> applyLinearImpulse: impulse [
	linearVelocity := linearVelocity + (impulse*inverseMass)
]

{ #category : #update }
WDPRigidBody >> clearNetForcesAndTorque [
	netForce := Vector3 zeros.
	netTorque := Vector3 zeros.
]

{ #category : #'mass distribution' }
WDPRigidBody >> computeMassDistribution [
	mass = 0 ifTrue: [ 
		self inertiaTensor: Matrix3x3 zeros.
	] ifFalse: [ 
		self inertiaTensor: (shape computeInertiaTensorWithMass: mass).
	]
]

{ #category : #accessing }
WDPRigidBody >> inertiaTensor [

	^ inertiaTensor
]

{ #category : #accessing }
WDPRigidBody >> inertiaTensor: aMatrix3x3 [
	inertiaTensor := aMatrix3x3.
	inverseInertiaTensor := (inertiaTensor determinant closeTo: 0)
		ifTrue: [ Matrix3x3 zeros ]
		ifFalse: [ inertiaTensor inverse ]
	
]

{ #category : #initialization }
WDPRigidBody >> initialize [
	super initialize.
	mass := inverseMass := 0.0.
	inertiaTensor := inverseInertiaTensor := Matrix3x3 zeros.
	linearDamping := self class defaultLinearDamping.
	angularDamping := self class defaultAngularDamping.
	netForce := Vector3 zeros.
	netTorque := Vector3 zeros.
]

{ #category : #update }
WDPRigidBody >> integrateMovementWithDeltaTime: deltaTime [
	| linearAcceleration integratedPosition integratedOrientation angularAcceleration |
	mass isZero ifTrue: [
		^ self
	].
	
	linearAcceleration := owner gravity + (linearVelocity * linearDamping negated) + (netForce * inverseMass).
	linearVelocity := linearVelocity + (linearAcceleration*deltaTime).
	integratedPosition := self position + (linearVelocity *deltaTime).

	angularAcceleration := (angularVelocity * angularDamping negated) + (worldInverseInertiaTensor * netTorque).
	angularVelocity := angularVelocity + (angularAcceleration*deltaTime).

	integratedOrientation := self orientation + ((Quaternion xyz: angularVelocity * 0.5 *deltaTime) * self orientation).
	integratedOrientation := integratedOrientation normalized.
	self position: integratedPosition orientation: integratedOrientation.

	self clearNetForcesAndTorque.
]

{ #category : #accessing }
WDPRigidBody >> inverseInertiaTensor [

	^ inverseInertiaTensor
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

{ #category : #accessing }
WDPRigidBody >> netForce [

	^ netForce
]

{ #category : #accessing }
WDPRigidBody >> netTorque [

	^ netTorque
]

{ #category : #accessing }
WDPRigidBody >> rotationMatrix [

	^ rotationMatrix
]

{ #category : #update }
WDPRigidBody >> transformChanged [
	super transformChanged.
	rotationMatrix := self orientation asMatrix3x3.
	worldInertiaTensor := rotationMatrix * inertiaTensor.
	worldInverseInertiaTensor := rotationMatrix * inverseInertiaTensor.
	
]

{ #category : #accessing }
WDPRigidBody >> worldInertiaTensor [

	^ worldInertiaTensor
]

{ #category : #accessing }
WDPRigidBody >> worldInverseInertiaTensor [

	^ worldInverseInertiaTensor
]
