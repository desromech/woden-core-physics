"
I am a generic collision object.
"
Class {
	#name : #WDPCollisionObject,
	#superclass : #Object,
	#instVars : [
		'owner',
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
WDPCollisionObject >> angularVelocity [

	^ angularVelocity
]

{ #category : #accessing }
WDPCollisionObject >> angularVelocity: anObject [

	angularVelocity := anObject
]

{ #category : #update }
WDPCollisionObject >> applyImpulse: impulse inPosition: worldPosition [
	self applyLinearImpulse: impulse
]

{ #category : #update }
WDPCollisionObject >> applyLinearImpulse: linearImpulse [
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

{ #category : #adding }
WDPCollisionObject >> constructVisualizationSceneNode [
	^ shape constructVisualizationSceneNode
		transform: transform;
		yourself
]

{ #category : #accessing }
WDPCollisionObject >> dynamicFrictionCoefficient [

	^ dynamicFrictionCoefficient
]

{ #category : #accessing }
WDPCollisionObject >> dynamicFrictionCoefficient: anObject [

	dynamicFrictionCoefficient := anObject
]

{ #category : #initialization }
WDPCollisionObject >> initialize [
	super initialize.
	shape := WDPNullCollisionShape uniqueInstance.

	transform := RigidTransform3D identity.
	linearVelocity := Vector3 zeros.
	angularVelocity := Vector3 zeros.
	
	restitutionCoefficient := 0.5.
	dynamicFrictionCoefficient := 0.5.
	staticFrictionCoefficient := 0.625.
	
	collisionGroup := WDPCollisionMasks defaultCollisionGroup .
	collisionResponseGroupMask := WDPCollisionMasks defaultCollisionResponseGroup.

]

{ #category : #update }
WDPCollisionObject >> integrateMovementWithDeltaTime: deltaTime [
]

{ #category : #accessing }
WDPCollisionObject >> inverseMass [
	^ 0.0
]

{ #category : #accessing }
WDPCollisionObject >> linearVelocity [

	^ linearVelocity
]

{ #category : #accessing }
WDPCollisionObject >> linearVelocity: anObject [

	linearVelocity := anObject
]

{ #category : #model }
WDPCollisionObject >> loadStateFromModel [
	model ifNotNil: [ 
		model loadCollisionStateInto: self.
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

{ #category : #transforming }
WDPCollisionObject >> translateBy: translation [
	self position: self position + translation
]
