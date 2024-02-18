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
		'netTorque',
		'linearAcceleration',
		'angularAcceleration',
		'linearVelocityIntegrationDelta',
		'angularVelocityIntegrationDelta'
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
WDPRigidBody >> angularAcceleration [

	^ angularAcceleration
]

{ #category : #accessing }
WDPRigidBody >> angularAcceleration: anObject [

	angularAcceleration := anObject
]

{ #category : #accessing }
WDPRigidBody >> angularDamping [

	^ angularDamping
]

{ #category : #accessing }
WDPRigidBody >> angularDamping: anObject [

	angularDamping := anObject
]

{ #category : #accessing }
WDPRigidBody >> angularVelocityIntegrationDelta [

	^ angularVelocityIntegrationDelta
]

{ #category : #accessing }
WDPRigidBody >> angularVelocityIntegrationDelta: anObject [

	angularVelocityIntegrationDelta := anObject
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

{ #category : #'as yet unclassified' }
WDPRigidBody >> applyMovement: movement atRelativePoint: relativePoint [
	| linearMovement angularMovement |
	linearMovement := movement * inverseMass.
	angularMovement := worldInverseInertiaTensor * (relativePoint cross: movement).
	self translateBy: linearMovement andRotateByAngularIncrement: angularMovement.
	
]

{ #category : #update }
WDPRigidBody >> clearNetForcesAndTorque [
	netForce := Vector3 zeros.
	netTorque := Vector3 zeros.
]

{ #category : #update }
WDPRigidBody >> computeAngularInertiaForRelativeContactPoint: relativePoint normal: normal [
	| torquePerUnitImpulse rotationPerUnitImpulse |
	torquePerUnitImpulse := relativePoint cross: normal.
	rotationPerUnitImpulse := worldInverseInertiaTensor * torquePerUnitImpulse.
	^ (rotationPerUnitImpulse cross: relativePoint) dot: normal
]

{ #category : #'mass distribution' }
WDPRigidBody >> computeMassDistribution [
	mass = 0 ifTrue: [ 
		self inertiaTensor: Matrix3x3 zeros.
	] ifFalse: [ 
		self inertiaTensor: (shape computeInertiaTensorWithMass: mass).
	]
]

{ #category : #update }
WDPRigidBody >> computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativePoint [
	| relativePointCrossMatrix torquePerUnitImpulse rotationPerUnitImpulse |
	relativePointCrossMatrix := Matrix3x3 skewSymmetric: relativePoint.
	torquePerUnitImpulse := relativePointCrossMatrix.
	rotationPerUnitImpulse := worldInverseInertiaTensor * torquePerUnitImpulse.
	^ (relativePointCrossMatrix * rotationPerUnitImpulse) negated
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
	| integratedVelocity integratedAngularVelocity integratedPosition integratedOrientation |
	mass isZero ifTrue: [
		angularAcceleration := linearAcceleration := Vector3 zeros.
		angularVelocityIntegrationDelta := linearVelocityIntegrationDelta := Vector3 zeros.
		^ self
	].
	
	"Integrate linear velocity."
	linearAcceleration := owner gravity + (netForce * inverseMass).
	
	integratedVelocity := self integrateVelocityWithAcceleration: linearAcceleration damping: linearDamping initialVelocity: linearVelocity dt: deltaTime.
	linearVelocityIntegrationDelta := integratedVelocity - linearVelocity.
	linearVelocity := integratedVelocity.

	"Integrate angular velocity."	
	angularAcceleration := (worldInverseInertiaTensor * netTorque).
	integratedAngularVelocity := self integrateVelocityWithAcceleration: angularAcceleration damping: angularDamping initialVelocity: angularVelocity dt: deltaTime.
	angularVelocityIntegrationDelta := integratedAngularVelocity - angularVelocity.
	angularVelocity := integratedAngularVelocity.

	"Integrate position"
	integratedPosition := self position + (linearVelocity *deltaTime).

	"Integrate orientation"
	integratedOrientation := (Quaternion xyz: angularVelocity * (0.5 *deltaTime)) exp * self orientation.
	integratedOrientation := integratedOrientation normalized.
	self position: integratedPosition orientation: integratedOrientation.

	self clearNetForcesAndTorque.
]

{ #category : #update }
WDPRigidBody >> integrateVelocityWithAcceleration: a damping: k initialVelocity: v0 dt: dt [
	^ (k closeTo: 0) ifTrue: [ 
		v0 + (a*dt)
	] ifFalse: [
		| ve | 
		ve := a / k.
		^ ve - ((ve - v0) * ((k negated * dt) exp))
	]
	"^ v0 + ((a - (v0*k))*dt)"
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
WDPRigidBody >> linearAcceleration [

	^ linearAcceleration
]

{ #category : #accessing }
WDPRigidBody >> linearAcceleration: anObject [

	^ linearAcceleration := anObject
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
WDPRigidBody >> linearVelocityIntegrationDelta [

	^ linearVelocityIntegrationDelta
]

{ #category : #accessing }
WDPRigidBody >> linearVelocityIntegrationDelta: anObject [

	^ linearVelocityIntegrationDelta := anObject
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
	| transposedRotationMatrix |
	super transformChanged.
	rotationMatrix := self orientation asMatrix3x3.
	transposedRotationMatrix := rotationMatrix transpose.

	worldInertiaTensor := rotationMatrix * inertiaTensor * transposedRotationMatrix.
	worldInverseInertiaTensor := rotationMatrix * inverseInertiaTensor * transposedRotationMatrix.

]

{ #category : #'as yet unclassified' }
WDPRigidBody >> velocityAtRelativePoint: relativePoint [
	^ linearVelocity + (angularVelocity cross: relativePoint)
]

{ #category : #accessing }
WDPRigidBody >> worldInertiaTensor [

	^ worldInertiaTensor
]

{ #category : #accessing }
WDPRigidBody >> worldInverseInertiaTensor [

	^ worldInverseInertiaTensor
]
