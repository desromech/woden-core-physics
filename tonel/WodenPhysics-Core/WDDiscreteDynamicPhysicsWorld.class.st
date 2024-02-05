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

{ #category : #'as yet unclassified' }
WDDiscreteDynamicPhysicsWorld >> computeBroadphaseCandidatePairs [
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
WDDiscreteDynamicPhysicsWorld >> computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs [
	| narrowPhaseContacts |
	narrowPhaseContacts := OrderedCollection new.
	broadphaseCandidatePairs do: [ :each |
		| contact | 
		contact := self detectNarrowphaseCollisionOf: each first with: each second.
		contact ifNotNil: [
			narrowPhaseContacts add: contact
		]
	].
	^ narrowPhaseContacts
]

{ #category : #update }
WDDiscreteDynamicPhysicsWorld >> detectAndResolveCollisionsWithDeltaTime: deltaTime [
	| broadphaseCandidatePairs narrowPhaseContacts |
	broadphaseCandidatePairs := self computeBroadphaseCandidatePairs.
	narrowPhaseContacts := self computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs.

	"Resolve the collision responses."
	narrowPhaseContacts do: [ :contact |
		self resolveCollisionResponse: contact
	].
	
	"Resolve the contact constraints."
	narrowPhaseContacts do: [ :contact |
		self resolveContactConstraints: contact
	].

]

{ #category : #'as yet unclassified' }
WDDiscreteDynamicPhysicsWorld >> detectNarrowphaseCollisionOf: firstCollisionObject with: secondCollisionObject [
	| firstShape firstTransform secondShape secondTransform contactManifold |
	firstShape := firstCollisionObject shape.
	firstTransform := firstCollisionObject transform.
	secondShape := secondCollisionObject shape.
	secondTransform := secondCollisionObject transform.
	
	contactManifold := firstShape detectAndComputeCollisionContactManifoldAt: firstTransform with: secondShape at: secondTransform.
	contactManifold ifNil: [ ^ nil ].
	
	^ contactManifold
		firstCollisionObject: firstCollisionObject;
		secondCollisionObject: secondCollisionObject;
		yourself
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

{ #category : #'as yet unclassified' }
WDDiscreteDynamicPhysicsWorld >> resolveCollisionResponse: contactManifold [
	| firstCollisionObject secondCollisionObject inverseMassSum relativeVelocity restitutionCoefficient relativeVelocityAlongNormal impulse contactNormal penetrationDelta |
	firstCollisionObject := contactManifold firstCollisionObject.
	secondCollisionObject := contactManifold secondCollisionObject.
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].

	contactNormal := contactManifold normal.
	
	relativeVelocity := secondCollisionObject linearVelocity - firstCollisionObject linearVelocity.
	relativeVelocityAlongNormal := relativeVelocity dot: contactNormal.
	relativeVelocityAlongNormal <= 0.0 ifTrue: [ ^ self ].
	
	restitutionCoefficient := firstCollisionObject restitutionCoefficient * secondCollisionObject restitutionCoefficient.
	impulse := (restitutionCoefficient + 1.0) * relativeVelocityAlongNormal / inverseMassSum.
	
	firstCollisionObject applyLinearImpulse: contactNormal * impulse.
	secondCollisionObject applyLinearImpulse: contactNormal * impulse negated.
	
	penetrationDelta := contactManifold minimumTranslationVector / inverseMassSum.
	firstCollisionObject translateBy: penetrationDelta * firstCollisionObject inverseMass.
	secondCollisionObject translateBy: penetrationDelta * secondCollisionObject inverseMass negated.

]

{ #category : #'as yet unclassified' }
WDDiscreteDynamicPhysicsWorld >> resolveContactConstraints: contactManifold [
]

{ #category : #update }
WDDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]
