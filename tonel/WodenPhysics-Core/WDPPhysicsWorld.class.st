"
I am a physics world.
"
Class {
	#name : #WDPPhysicsWorld,
	#superclass : #Object,
	#instVars : [
		'collisionObjects',
		'collisionObjectTree',
		'collisionObjectIdCount',
		'contactManifoldCache',
		'restingContactVelocityLimit'
	],
	#category : #'WodenPhysics-Core-World'
}

{ #category : #testing }
WDPPhysicsWorld class >> isAbstract [
	^ self == WDPPhysicsWorld
]

{ #category : #adding }
WDPPhysicsWorld >> add: aPhysicsWorldObject [
	aPhysicsWorldObject addOntoPhysicsWorld: self
]

{ #category : #adding }
WDPPhysicsWorld >> addCollisionObject: aCollisionObject [
	self assert: aCollisionObject owner isNil.
	self assert: aCollisionObject collisionTreeNode isNil.
	
	collisionObjects add: aCollisionObject.
	aCollisionObject collisionTreeNode: (collisionObjectTree insertValue: aCollisionObject withBoundingBox: aCollisionObject boundingBoxWithMargin).
	aCollisionObject owner: self; id: collisionObjectIdCount.
	collisionObjectIdCount := collisionObjectIdCount + 1.
	
]

{ #category : #visualization }
WDPPhysicsWorld >> buildInteractiveVisualizationScene [
	| scene collisionObjectsWithSceneNodes contactPointMeshes contactPointsNode updateSlowDownFactor updateFrameId |
	scene := WDScene new.
	scene add: (WDDirectionalLightSource new
		color: (Vector3 x: 1.0 y: 1.0 z: 0.8) normalized;
		intensity: 0.7;
		yourself).
	collisionObjectsWithSceneNodes := collisionObjects collect: [ :collisionObject |
		| sceneNode |
		sceneNode := collisionObject constructVisualizationSceneNode.
		scene add: sceneNode.
		collisionObject -> sceneNode
	].

	contactPointMeshes := {
		WDMeshBuilder new
			currentMaterial: (WDUnlitMaterial new
				colorFactor: Color red;
				xray: true;
				yourself);
			addCubeWithHalfExtent: (Vector3 withAll: 0.05);
			mesh.

		WDMeshBuilder new
			currentMaterial: (WDUnlitMaterial new
				colorFactor: Color blue;
				xray: true;
				yourself);
			addCubeWithHalfExtent: (Vector3 withAll: 0.05);
			mesh.
	}.
	contactPointsNode := WDSceneNode new.
	scene add: contactPointsNode.
	
	updateSlowDownFactor := 1.
	updateFrameId := 0.
	scene updateBlock: [ :deltaTime |
		(updateFrameId % updateSlowDownFactor) = 0 ifTrue: [
			self updateWithDeltaTime: deltaTime.
			collisionObjectsWithSceneNodes do: [ :each |
				each value transform: each key transform
			].
	
			contactPointsNode removeAllChildren.
			self worldSpaceContactPointsDo: [ :contactPoint :objectIndex |
				contactPointsNode add: (WDSceneNode new
					renderables: {contactPointMeshes at: objectIndex};
					position: contactPoint;
					yourself)
			].
		].
	
		updateFrameId := updateFrameId + 1.
		true
	].
	^ scene
]

{ #category : #update }
WDPPhysicsWorld >> collisionObjectTransformChanged: aCollisionObject [
	self assert: aCollisionObject collisionTreeNode isNotNil.
	collisionObjectTree updateLeafNode: aCollisionObject collisionTreeNode boundingBox: aCollisionObject boundingBoxWithMargin
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> composeCollisionId: firstId with: secondId [
	^ firstId | (secondId << 32)
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> findBroadphasePairsFor: collidingObject into: pairsList pairSet: pairsSet [
	| boundingBoxToFind |
	boundingBoxToFind := collidingObject boundingBoxWithMargin.
	collisionObjectTree leavesIntersectingBox: boundingBoxToFind do: [ :eachLeafNode |
		| eachCollisionObject |
		eachCollisionObject := eachLeafNode value.
		(eachCollisionObject ~~ collidingObject and: [
			(self hasToConsiderInBroadphase: collidingObject with: eachCollisionObject)]) ifTrue: [ 
			| firstObject secondObject pairId |
			self assert: collidingObject id ~= eachCollisionObject id.
			collidingObject id < eachCollisionObject id ifTrue: [ 
				firstObject := collidingObject.
				secondObject := eachCollisionObject
			] ifFalse: [ 
				firstObject := eachCollisionObject.
				secondObject := collidingObject
			].
			
			pairId := self composeCollisionId: firstObject id with: secondObject id.
			(pairsSet includes: pairId) ifFalse: [
				pairsList add: {firstObject . secondObject}.
				pairsSet add: pairId
			]
		].
	]
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> hasToConsiderInBroadphase: firstObject with: secondObject [
	^ (firstObject collisionResponseGroupMask anyMask: secondObject collisionGroup) or: 
		(secondObject collisionResponseGroupMask anyMask: firstObject collisionGroup)
]

{ #category : #initialization }
WDPPhysicsWorld >> initialize [
	super initialize.
	collisionObjects := OrderedCollection new.
	collisionObjectTree := WMDbvt new.
	collisionObjectIdCount := 0.
	contactManifoldCache := WDPContactManifoldCache new.
	restingContactVelocityLimit := 0.1
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> loadCollisionStateFromModels [
	collisionObjects do: [ :each | each loadStateFromModel ]
]

{ #category : #accessing }
WDPPhysicsWorld >> restingContactVelocityLimit [

	^ restingContactVelocityLimit
]

{ #category : #accessing }
WDPPhysicsWorld >> restingContactVelocityLimit: anObject [

	restingContactVelocityLimit := anObject
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> saveCollisionStateIntoModels [
	collisionObjects do: [ :each | each saveStateFromModel ]
]

{ #category : #update }
WDPPhysicsWorld >> updateWithDeltaTime: deltaTime [
]

{ #category : #enumerating }
WDPPhysicsWorld >> worldSpaceContactPointsDo: aBlock [
]
