"
I am a physics world.
"
Class {
	#name : #WDPhysicsWorld,
	#superclass : #Object,
	#instVars : [
		'collisionObjects'
	],
	#category : #'WodenPhysics-Core-World'
}

{ #category : #testing }
WDPhysicsWorld class >> isAbstract [
	^ self == WDPhysicsWorld
]

{ #category : #adding }
WDPhysicsWorld >> add: aPhysicsWorldObject [
	aPhysicsWorldObject addOntoPhysicsWorld: self
]

{ #category : #adding }
WDPhysicsWorld >> addCollisionObject: aCollisionObject [
	self assert: aCollisionObject owner isNil.
	aCollisionObject owner: self.
	collisionObjects add: aCollisionObject
]

{ #category : #visualization }
WDPhysicsWorld >> buildInteractiveVisualizationScene [
	| scene collisionObjectsWithSceneNodes |
	scene := WDScene new.
	scene add: (WDDirectionalLightSource new
		intensity: (Vector3 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
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

{ #category : #'as yet unclassified' }
WDPhysicsWorld >> computeBroadphaseCandidatePairs [
	| pairSet broadphasePairs |
	pairSet := Set new.	
	broadphasePairs := OrderedCollection new.
	collisionObjects do: [ :each |
		each needsCollisionDetection ifTrue: [ 
			self findBroadphasePairsFor: each into: broadphasePairs pairSet: pairSet
		]
	].
	^ broadphasePairs
]

{ #category : #'as yet unclassified' }
WDPhysicsWorld >> findBroadphasePairsFor: collidingObject into: pairsList pairSet: pairsSet [
	| boundingBoxToFind |
	boundingBoxToFind := collidingObject boundingBoxWithMargin.
	collisionObjects do: [ :each |
		(each ~~ collidingObject and: [ boundingBoxToFind hasIntersectionWithBox: each boundingBoxWithMargin ]) ifTrue: [ 
			| firstPair secondPair |
			firstPair := { each . collidingObject }.
			secondPair := { collidingObject . each }.
			((pairsSet includes: firstPair) or: (pairsSet includes: secondPair)) ifFalse: [ 
				pairsList add: firstPair.
				pairsSet add: firstPair
			]
		].
	]
]

{ #category : #initialization }
WDPhysicsWorld >> initialize [
	super initialize.
	collisionObjects := OrderedCollection new.
]

{ #category : #update }
WDPhysicsWorld >> updateWithDeltaTime: deltaTime [
]
