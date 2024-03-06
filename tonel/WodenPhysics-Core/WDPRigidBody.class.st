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
		'angularVelocityIntegrationDelta',
		'contactIslandId',
		'contactIslandParent',
		'isAwake',
		'averageMovementAmount',
		'internalAcceleration'
	],
	#category : #'WodenPhysics-Core-CollisionObjects'
}

{ #category : #defaults }
WDPRigidBody class >> angularMovementLimit [
	^ 0.2
]

{ #category : #defaults }
WDPRigidBody class >> averageMovementAmountSleepingThreshold [
	^ 0.01
]

{ #category : #defaults }
WDPRigidBody class >> defaultAngularDamping [
	^ 0.2
]

{ #category : #defaults }
WDPRigidBody class >> defaultLinearDamping [
	^ 0.2
]

{ #category : #defaults }
WDPRigidBody class >> wakeUpMovementDeltaTreshold [
	^ 0.001
]

{ #category : #defaults }
WDPRigidBody class >> wakingUpAverageMovementAmount [
	^ 2.0
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
	angularVelocity := angularVelocity + (worldInverseInertiaTensor * impulse).
	self checkWakeUpDueToExternalImpulse
]

{ #category : #update }
WDPRigidBody >> applyForce: force [
	netForce := netForce + force.
	self wakeUp
]

{ #category : #update }
WDPRigidBody >> applyForce: force inRelativePosition: relativePosition [
	netForce := netForce + force.
	netTorque := netTorque + (relativePosition cross: force).
	self wakeUp
]

{ #category : #update }
WDPRigidBody >> applyImpulse: impulse inPosition: worldPosition [
	self applyImpulse: impulse inRelativePosition: worldPosition - self position
]

{ #category : #update }
WDPRigidBody >> applyImpulse: impulse inRelativePosition: relativePosition [
	linearVelocity := linearVelocity + (impulse*inverseMass).
	angularVelocity := angularVelocity + (worldInverseInertiaTensor * (relativePosition cross: impulse)).
	self checkWakeUpDueToExternalImpulse
]

{ #category : #update }
WDPRigidBody >> applyLinearImpulse: impulse [
	linearVelocity := linearVelocity + (impulse*inverseMass).
	self checkWakeUpDueToExternalImpulse.
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> applyMovement: movement atRelativePoint: relativePoint withDirection: movementDirection [
	| linearMovement angularMovement angularDirection angularFactor angularMovementLimit |
	linearMovement := movement * inverseMass.

	angularDirection := worldInverseInertiaTensor * (relativePoint cross: movementDirection).
	angularFactor := angularDirection length.
	(angularFactor closeTo: 0.0) ifTrue: [
		^ self wakeUpForTranslationBy: movementDirection * linearMovement
	].

	angularDirection := angularDirection / angularFactor.

	angularMovement := movement * angularFactor.
	angularMovement abs <= 0.0 ifTrue: [ 
		^ self wakeUpForTranslationBy: movementDirection * linearMovement
	].

	angularMovementLimit := self class angularMovementLimit.
	angularMovement abs > self class angularMovementLimit ifTrue: [
		| angularSpentMovement |
		angularMovement := angularMovement >= 0
			ifTrue: [ angularMovementLimit ]
			ifFalse: [ angularMovementLimit negated ].
		
		angularSpentMovement := angularMovement / angularFactor.
		self assert: angularSpentMovement >= 0.
		linearMovement := (movement - angularSpentMovement) * inverseMass.
	].

	self wakeUpForTranslationBy: movementDirection * linearMovement andRotateByAngularIncrement: angularDirection*angularMovement
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> checkTimeToSleep: weight [
	| movementAmount |
	isAwake ifFalse: [ ^ self ].
	
	movementAmount := self movementAmount.
	averageMovementAmount := averageMovementAmount interpolateTo: movementAmount at: weight.
	averageMovementAmount <= self class averageMovementAmountSleepingThreshold ifTrue: [
		"Transcript show: id; show: ' got to sleep'; cr."
		self setSleepingStateFactors
	]
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> checkWakeUpDueToExternalImpulse [
	isAwake ifTrue: [ ^ self ].
	self movementAmount > self class averageMovementAmountSleepingThreshold ifTrue: [ 
		self wakeUp
	]
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
WDPRigidBody >> contactIslandId [

	^ contactIslandId
]

{ #category : #accessing }
WDPRigidBody >> contactIslandId: anObject [

	contactIslandId := anObject
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> getContactIslandRoot [
	self == contactIslandParent ifTrue: [ ^ self ].
	^ contactIslandParent := contactIslandParent getContactIslandRoot
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
	internalAcceleration := Vector3 zeros.
	linearDamping := self class defaultLinearDamping.
	angularDamping := self class defaultAngularDamping.
	netForce := Vector3 zeros.
	netTorque := Vector3 zeros.
	self setSleepingStateFactors.
]

{ #category : #update }
WDPRigidBody >> integrateMovementWithDeltaTime: deltaTime [
	| integratedVelocity integratedAngularVelocity integratedPosition integratedOrientation |
	mass isZero ifTrue: [
		self setSleepingStateFactors.
		^ self
	].
	
	"Integrate linear velocity."
	linearAcceleration := owner gravity + (netForce * inverseMass) + internalAcceleration.
	
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
WDPRigidBody >> internalAcceleration [

	^ internalAcceleration
]

{ #category : #accessing }
WDPRigidBody >> internalAcceleration: anObject [
	internalAcceleration := anObject.
	linearAcceleration length2 > 0.0 ifTrue: [ self wakeUp ]
]

{ #category : #accessing }
WDPRigidBody >> inverseInertiaTensor [

	^ inverseInertiaTensor
]

{ #category : #accessing }
WDPRigidBody >> inverseMass [

	^ inverseMass
]

{ #category : #testing }
WDPRigidBody >> isAwake [
	^ isAwake
]

{ #category : #initialization }
WDPRigidBody >> joinContactIslandWith: other [
	self assert: other participatesInContactResolution.
	contactIslandParent == self ifTrue: [ 
		contactIslandParent := other getContactIslandRoot
	] ifFalse: [ 
		self getContactIslandRoot joinContactIslandWith: other
	].

]

{ #category : #accessing }
WDPRigidBody >> linearAcceleration [

	^ linearAcceleration
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

{ #category : #'as yet unclassified' }
WDPRigidBody >> movementAmount [
	^ linearVelocity length2 + angularVelocity length2
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

{ #category : #'as yet unclassified' }
WDPRigidBody >> participatesInContactResolution [
	^ inverseMass ~= 0
]

{ #category : #initialization }
WDPRigidBody >> resetContactIslandRoot [
	contactIslandParent := self.
	contactIslandId := nil.
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> resetSleepingState [
	isAwake := false.
]

{ #category : #accessing }
WDPRigidBody >> rotationMatrix [

	^ rotationMatrix
]

{ #category : #update }
WDPRigidBody >> setSleepingStateFactors [
	isAwake := false.
	angularAcceleration := linearAcceleration := Vector3 zeros.
	angularVelocityIntegrationDelta := linearVelocityIntegrationDelta := Vector3 zeros.
	linearVelocity := angularVelocity := Vector3 zeros.
	averageMovementAmount := 0.
	self clearNetForcesAndTorque
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

{ #category : #'as yet unclassified' }
WDPRigidBody >> wakeUp [
	isAwake ifTrue: [ ^ self ].
	inverseMass = 0 ifTrue: [ ^ self ].
	
	"Transcript show: id; show: ' wakeUp'; cr."
	isAwake := true.
	averageMovementAmount := self class wakingUpAverageMovementAmount.
	owner ifNotNil: [ 
		owner addAwakeRigidBody: self
	]
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> wakeUpForTranslationBy: linearIncrement [
	isAwake ifFalse: [
		| movementAmount |
		movementAmount := linearIncrement length2.
		movementAmount < self class wakeUpMovementDeltaTreshold ifTrue: [ ^ self ].
		self wakeUp
	].

	self translateBy: linearIncrement
]

{ #category : #'as yet unclassified' }
WDPRigidBody >> wakeUpForTranslationBy: linearIncrement andRotateByAngularIncrement: angularIncrement [
	isAwake ifFalse: [
		| movementAmount |
		movementAmount := linearIncrement length2 + angularIncrement length2.
		movementAmount < self class wakeUpMovementDeltaTreshold ifTrue: [ ^ self ].
		self wakeUp
	].

	self translateBy: linearIncrement andRotateByAngularIncrement: angularIncrement
]

{ #category : #accessing }
WDPRigidBody >> worldInertiaTensor [

	^ worldInertiaTensor
]

{ #category : #accessing }
WDPRigidBody >> worldInverseInertiaTensor [

	^ worldInverseInertiaTensor
]
