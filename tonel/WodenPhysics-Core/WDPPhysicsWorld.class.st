"
I am a physics world.
"
Class {
	#name : #WDPPhysicsWorld,
	#superclass : #Object,
	#instVars : [
		'collisionObjects',
		'collisionObjectTree'
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
	aCollisionObject owner: self.
	
]

{ #category : #visualization }
WDPPhysicsWorld >> buildInteractiveVisualizationScene [
	| scene collisionObjectsWithSceneNodes |
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
	scene updateBlock: [ :deltaTime |
		self updateWithDeltaTime: deltaTime.
		collisionObjectsWithSceneNodes do: [ :each |
			each value transform: each key transform
		].
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
WDPPhysicsWorld >> findBroadphasePairsFor: collidingObject into: pairsList pairSet: pairsSet [
	| boundingBoxToFind |
	boundingBoxToFind := collidingObject boundingBoxWithMargin.
	collisionObjectTree leavesIntersectingBox: boundingBoxToFind do: [ :eachLeafNode |
		| eachCollisionObject |
		eachCollisionObject := eachLeafNode value.
		(eachCollisionObject ~~ collidingObject and: [
			(self hasToConsiderInBroadphase: collidingObject with: eachCollisionObject)]) ifTrue: [ 
			| firstPair secondPair |
			firstPair := { eachCollisionObject . collidingObject }.
			secondPair := { collidingObject . eachCollisionObject }.
			((pairsSet includes: firstPair) or: (pairsSet includes: secondPair)) ifFalse: [ 
				pairsList add: firstPair.
				pairsSet add: firstPair
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
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> loadCollisionStateFromModels [
	collisionObjects do: [ :each | each loadStateFromModel ]
]

{ #category : #'as yet unclassified' }
WDPPhysicsWorld >> saveCollisionStateIntoModels [
	collisionObjects do: [ :each | each saveStateFromModel ]
]

{ #category : #update }
WDPPhysicsWorld >> updateWithDeltaTime: deltaTime [
]
