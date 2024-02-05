"
I am a generic collision object.
"
Class {
	#name : #WDCollisionObject,
	#superclass : #Object,
	#instVars : [
		'owner',
		'shape',
		'transform',
		'linearVelocity',
		'angularVelocity',
		'restitutionCoefficient',
		'dynamicFrictionCoefficient',
		'staticFrictionCoefficient'
	],
	#category : #'WodenPhysics-Core-RigidBody'
}

{ #category : #adding }
WDCollisionObject >> addOntoPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld addCollisionObject: self
]

{ #category : #accessing }
WDCollisionObject >> angularVelocity [

	^ angularVelocity
]

{ #category : #accessing }
WDCollisionObject >> angularVelocity: anObject [

	angularVelocity := anObject
]

{ #category : #'as yet unclassified' }
WDCollisionObject >> applyImpulse: impulse inPosition: worldPosition [
	self applyLinearImpulse: impulse
]

{ #category : #'as yet unclassified' }
WDCollisionObject >> applyLinearImpulse: linearImpulse [
	"By default do nothing."
]

{ #category : #accessing }
WDCollisionObject >> boundingBoxWithMargin [
	^ self localBoundingBoxWithMargin transformedWith: transform
]

{ #category : #adding }
WDCollisionObject >> constructVisualizationSceneNode [
	^ shape constructVisualizationSceneNode
		transform: transform;
		yourself
]

{ #category : #accessing }
WDCollisionObject >> dynamicFrictionCoefficient [

	^ dynamicFrictionCoefficient
]

{ #category : #accessing }
WDCollisionObject >> dynamicFrictionCoefficient: anObject [

	dynamicFrictionCoefficient := anObject
]

{ #category : #initialization }
WDCollisionObject >> initialize [
	super initialize.
	shape := WDNullCollisionShape uniqueInstance.

	transform := RigidTransform3D identity.
	linearVelocity := Vector3 zeros.
	angularVelocity := Vector3 zeros.
	
	restitutionCoefficient := 0.5.
	dynamicFrictionCoefficient := 0.5.
	staticFrictionCoefficient := 0.625.

]

{ #category : #update }
WDCollisionObject >> integrateMovementWithDeltaTime: deltaTime [
]

{ #category : #accessing }
WDCollisionObject >> linearVelocity [

	^ linearVelocity
]

{ #category : #accessing }
WDCollisionObject >> linearVelocity: anObject [

	linearVelocity := anObject
]

{ #category : #accessing }
WDCollisionObject >> localBoundingBoxWithMargin [
	^ shape localBoundingBoxWithMargin
]

{ #category : #testing }
WDCollisionObject >> needsCollisionDetection [
	^ false
]

{ #category : #accessing }
WDCollisionObject >> orientation [
	^ transform rotation
]

{ #category : #accessing }
WDCollisionObject >> orientation: anOrientation [
	transform rotation: anOrientation
]

{ #category : #accessing }
WDCollisionObject >> owner [

	^ owner
]

{ #category : #accessing }
WDCollisionObject >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
WDCollisionObject >> position [
	^ transform translation
]

{ #category : #accessing }
WDCollisionObject >> position: aPosition [
	transform translation: aPosition
]

{ #category : #'as yet unclassified' }
WDCollisionObject >> rejectLinearVelocityAlongAxis: axis [
	linearVelocity := linearVelocity - (axis * (linearVelocity dot: axis))
]

{ #category : #accessing }
WDCollisionObject >> restitutionCoefficient [

	^ restitutionCoefficient
]

{ #category : #accessing }
WDCollisionObject >> restitutionCoefficient: anObject [

	restitutionCoefficient := anObject
]

{ #category : #accessing }
WDCollisionObject >> shape [

	^ shape
]

{ #category : #accessing }
WDCollisionObject >> shape: anObject [

	shape := anObject
]

{ #category : #accessing }
WDCollisionObject >> staticFrictionCoefficient [

	^ staticFrictionCoefficient
]

{ #category : #accessing }
WDCollisionObject >> staticFrictionCoefficient: anObject [

	staticFrictionCoefficient := anObject
]

{ #category : #accessing }
WDCollisionObject >> transform [

	^ transform
]

{ #category : #accessing }
WDCollisionObject >> transform: anObject [

	transform := anObject
]

{ #category : #transforming }
WDCollisionObject >> translateBy: translation [
	self position: self position + translation
]
