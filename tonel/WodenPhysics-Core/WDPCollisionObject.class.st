"
I am a generic collision object.
"
Class {
	#name : #WDPCollisionObject,
	#superclass : #Object,
	#instVars : [
		'owner',
		'id',
		'collisionTreeNode',
		'shape',
		'transform',
		'linearVelocity',
		'angularVelocity',
		'restitutionCoefficient',
		'dynamicFrictionCoefficient',
		'staticFrictionCoefficient',
		'model',
		'collisionGroup',
		'collisionResponseGroupMask'
	],
	#category : #'WodenPhysics-Core-CollisionObjects'
}

{ #category : #adding }
WDPCollisionObject >> addOntoPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld addCollisionObject: self
]

{ #category : #accessing }
WDPCollisionObject >> angularAcceleration [
	^ Vector3 zeros
]

{ #category : #accessing }
WDPCollisionObject >> angularVelocity [

	^ angularVelocity
]

{ #category : #accessing }
WDPCollisionObject >> angularVelocity: anObject [

	angularVelocity := anObject
]

{ #category : #accessing }
WDPCollisionObject >> angularVelocityIntegrationDelta [
	^ Vector3 zeros
]

{ #category : #update }
WDPCollisionObject >> applyAngularImpulse: angularImpulse [
	"By default do nothing."
]

{ #category : #update }
WDPCollisionObject >> applyForce: force [
	"By default do nothing."
]

{ #category : #update }
WDPCollisionObject >> applyForce: force inPosition: worldPosition [
	self applyForce: force inRelativePosition: worldPosition - self position
]

{ #category : #update }
WDPCollisionObject >> applyForce: force inRelativePosition: relativePosition [
	"By default do nothing."
]

{ #category : #update }
WDPCollisionObject >> applyImpulse: impulse inPosition: worldPosition [
	self applyLinearImpulse: impulse
]

{ #category : #update }
WDPCollisionObject >> applyImpulse: impulse inRelativePosition: worldPosition [
	self applyLinearImpulse: impulse
]

{ #category : #update }
WDPCollisionObject >> applyLinearImpulse: linearImpulse [
	"By default do nothing."
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> applyMovement: movement atRelativePoint: relativePoint withDirection: movementDirection [
]

{ #category : #update }
WDPCollisionObject >> applyTorque: force [
	"By default do nothing."
]

{ #category : #accessing }
WDPCollisionObject >> boundingBoxWithMargin [
	^ self localBoundingBoxWithMargin transformedWith: transform
]

{ #category : #accessing }
WDPCollisionObject >> collisionGroup [

	^ collisionGroup
]

{ #category : #accessing }
WDPCollisionObject >> collisionGroup: anObject [

	collisionGroup := anObject
]

{ #category : #accessing }
WDPCollisionObject >> collisionResponseGroupMask [

	^ collisionResponseGroupMask
]

{ #category : #accessing }
WDPCollisionObject >> collisionResponseGroupMask: anObject [

	collisionResponseGroupMask := anObject
]

{ #category : #accessing }
WDPCollisionObject >> collisionTreeNode [

	^ collisionTreeNode
]

{ #category : #accessing }
WDPCollisionObject >> collisionTreeNode: anObject [

	collisionTreeNode := anObject
]

{ #category : #update }
WDPCollisionObject >> computeAngularInertiaForRelativeContactPoint: relativePoint normal: normal [
	^ 0.0
]

{ #category : #update }
WDPCollisionObject >> computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativePoint [
	^ Matrix3x3 zeros
]

{ #category : #adding }
WDPCollisionObject >> constructVisualizationSceneNode [
	^ shape constructVisualizationSceneNode
		transform: transform;
		yourself
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> contactIslandRoot [
	^ nil
]

{ #category : #accessing }
WDPCollisionObject >> dynamicFrictionCoefficient [

	^ dynamicFrictionCoefficient
]

{ #category : #accessing }
WDPCollisionObject >> dynamicFrictionCoefficient: anObject [

	dynamicFrictionCoefficient := anObject
]

{ #category : #accessing }
WDPCollisionObject >> id [

	^ id
]

{ #category : #accessing }
WDPCollisionObject >> id: anObject [

	id := anObject
]

{ #category : #accessing }
WDPCollisionObject >> inertiaTensor [
	^ Matrix3x3 zeros
]

{ #category : #initialization }
WDPCollisionObject >> initialize [
	super initialize.
	id := -1.
	shape := WDPNullCollisionShape uniqueInstance.

	transform := RigidTransform3D identity.
	linearVelocity := Vector3 zeros.
	angularVelocity := Vector3 zeros.
	
	restitutionCoefficient := 0.2.
	dynamicFrictionCoefficient := 0.5.
	staticFrictionCoefficient := 0.6.
	
	collisionGroup := WDPCollisionMasks defaultCollisionGroup .
	collisionResponseGroupMask := WDPCollisionMasks defaultCollisionResponseGroup.

]

{ #category : #update }
WDPCollisionObject >> integrateMovementWithDeltaTime: deltaTime [
]

{ #category : #accessing }
WDPCollisionObject >> inverseInertiaTensor [
	^ Matrix3x3 zeros
]

{ #category : #accessing }
WDPCollisionObject >> inverseMass [
	^ 0.0
]

{ #category : #testing }
WDPCollisionObject >> isAwake [
	^ false
]

{ #category : #testing }
WDPCollisionObject >> isSleeping [
	^ self isAwake not
]

{ #category : #accessing }
WDPCollisionObject >> linearAcceleration [
	^ Vector3 zeros
]

{ #category : #accessing }
WDPCollisionObject >> linearVelocity [

	^ linearVelocity
]

{ #category : #accessing }
WDPCollisionObject >> linearVelocity: anObject [

	linearVelocity := anObject
]

{ #category : #accessing }
WDPCollisionObject >> linearVelocityIntegrationDelta [
	^ Vector3 zeros
]

{ #category : #model }
WDPCollisionObject >> loadStateFromModelWithDeltaTime: deltaTime [
	model ifNotNil: [ 
		model loadCollisionStateInto: self deltaTime: deltaTime.
	].

]

{ #category : #accessing }
WDPCollisionObject >> localBoundingBoxWithMargin [
	^ shape localBoundingBoxWithMargin
]

{ #category : #accessing }
WDPCollisionObject >> mass [
	^ 0.0
]

{ #category : #accessing }
WDPCollisionObject >> model [

	^ model
]

{ #category : #accessing }
WDPCollisionObject >> model: anObject [

	model := anObject
]

{ #category : #testing }
WDPCollisionObject >> needsCollisionDetection [
	^ false
]

{ #category : #accessing }
WDPCollisionObject >> orientation [
	^ transform rotation
]

{ #category : #accessing }
WDPCollisionObject >> orientation: anOrientation [
	transform rotation: anOrientation.
	self transformChanged
]

{ #category : #accessing }
WDPCollisionObject >> owner [

	^ owner
]

{ #category : #accessing }
WDPCollisionObject >> owner: anObject [

	owner := anObject
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> participatesInContactResolution [
	^ false
]

{ #category : #accessing }
WDPCollisionObject >> position [
	^ transform translation
]

{ #category : #accessing }
WDPCollisionObject >> position: aPosition [
	transform translation: aPosition.
	self transformChanged
]

{ #category : #accessing }
WDPCollisionObject >> position: aPosition orientation: anOrientation [
	transform
		rotation: anOrientation;
		translation: aPosition.
	self transformChanged
]

{ #category : #accessing }
WDPCollisionObject >> rayCast: ray [
	| localRay localRayResult |
	localRay := ray inverseTransformedWith: transform.
	localRayResult := shape rayCast: localRay.
	localRayResult ifNil: [ ^ nil ].
	
	^ WDPCollisionObjectRayCastingResult new
		collisionObject: self;
		shape: localRayResult shape;
		distance: localRayResult distance;
		normal: localRayResult normal;
		yourself
	
]

{ #category : #adding }
WDPCollisionObject >> removeFromPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld removeCollisionObject: self
]

{ #category : #initialization }
WDPCollisionObject >> resetContactIslandRoot [
]

{ #category : #initialization }
WDPCollisionObject >> resetSleepingState [
]

{ #category : #accessing }
WDPCollisionObject >> restitutionCoefficient [

	^ restitutionCoefficient
]

{ #category : #accessing }
WDPCollisionObject >> restitutionCoefficient: anObject [

	restitutionCoefficient := anObject
]

{ #category : #model }
WDPCollisionObject >> saveStateFromModel [
	model ifNotNil: [ 
		model saveCollisionStateFrom: self.
	].

]

{ #category : #accessing }
WDPCollisionObject >> shape [

	^ shape
]

{ #category : #accessing }
WDPCollisionObject >> shape: anObject [

	shape := anObject
]

{ #category : #accessing }
WDPCollisionObject >> staticFrictionCoefficient [

	^ staticFrictionCoefficient
]

{ #category : #accessing }
WDPCollisionObject >> staticFrictionCoefficient: anObject [

	staticFrictionCoefficient := anObject
]

{ #category : #accessing }
WDPCollisionObject >> transform [

	^ transform
]

{ #category : #accessing }
WDPCollisionObject >> transform: aTransform [
	transform := aTransform asTRSTransform3D copy.
	self transformChanged
]

{ #category : #accessing }
WDPCollisionObject >> transformChanged [
	owner ifNotNil: [ 
		owner collisionObjectTransformChanged: self
	]
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> transformLocalPosition: localPosition [
	^ transform transformPosition: localPosition
]

{ #category : #transforming }
WDPCollisionObject >> translateBy: translation [
	self position: self position + translation
]

{ #category : #transforming }
WDPCollisionObject >> translateBy: linearIncrement andRotateByAngularIncrement: angularIncrement [
	transform translation: transform translation + linearIncrement.
	transform rotation: (Quaternion xyz: angularIncrement * 0.5) exp * transform rotation.
	self transformChanged 
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> velocityAtRelativePoint: relativePoint [
	^ Vector3 zeros
]

{ #category : #'as yet unclassified' }
WDPCollisionObject >> wakeUp [
]

{ #category : #accessing }
WDPCollisionObject >> worldInertiaTensor [
	^ Matrix3x3 zeros
]

{ #category : #accessing }
WDPCollisionObject >> worldInverseInertiaTensor [
	^ Matrix3x3 zeros
]
