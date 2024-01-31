"
I am a physics world that performs simulations by using discrete collision detection.
"
Class {
	#name : #WDDiscreteDynamicPhysicsWorld,
	#superclass : #WDPhysicsWorld,
	#instVars : [
		'gravity'
	],
	#category : #'WodenPhysics-Core-World'
}

{ #category : #update }
WDDiscreteDynamicPhysicsWorld >> detectAndResolveCollisionsWithDeltaTime: deltaTime [
	| broadphaseCandidatePairs |
	broadphaseCandidatePairs := self computeBroadphaseCandidatePairs.
	broadphaseCandidatePairs do: [ :each |
		self detectAndResolveNarrowphaseCollisionOf: each first with: each second
	]
]

{ #category : #'as yet unclassified' }
WDDiscreteDynamicPhysicsWorld >> detectAndResolveNarrowphaseCollisionOf: firstCollisionObject with: secondCollisionObject [
	| firstShape firstTransform secondShape secondTransform contactManifold mtv |
	(firstCollisionObject inverseMass isZero and: [ secondCollisionObject inverseMass isZero ]) ifTrue: [ ^ self ].
	
	firstShape := firstCollisionObject shape.
	firstTransform := firstCollisionObject transform.
	secondShape := secondCollisionObject shape.
	secondTransform := secondCollisionObject transform.
	
	contactManifold := firstShape detectAndComputeCollisionContactManifoldAt: firstTransform with: secondShape at: secondTransform.
	contactManifold ifNil: [ ^ self ].

	"TODO: Compute the actual impulse."
	mtv := contactManifold minimumTranslationVector.
	Transcript show: firstCollisionObject position; show: ' <-> '; show: secondCollisionObject position; show: ' : '; show: contactManifold; cr.
	
	firstCollisionObject inverseMass ~= 0 ifTrue: [ 
		firstCollisionObject
			translateBy: mtv;
			rejectLinearVelocityAlongAxis: contactManifold normal.
	].

	secondCollisionObject inverseMass ~= 0 ifTrue: [ 
		secondCollisionObject
			translateBy: mtv negated;
			rejectLinearVelocityAlongAxis: contactManifold normal
	].

]

{ #category : #accessing }
WDDiscreteDynamicPhysicsWorld >> gravity [

	^ gravity
]

{ #category : #accessing }
WDDiscreteDynamicPhysicsWorld >> gravity: anObject [

	gravity := anObject
]

{ #category : #initialization }
WDDiscreteDynamicPhysicsWorld >> initialize [
	super initialize.
	gravity := Vector3 zeros.
]

{ #category : #update }
WDDiscreteDynamicPhysicsWorld >> integrateMovementWithDeltaTime: deltaTime [
	collisionObjects do: [ :each | each integrateMovementWithDeltaTime: deltaTime ]
]

{ #category : #update }
WDDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]
