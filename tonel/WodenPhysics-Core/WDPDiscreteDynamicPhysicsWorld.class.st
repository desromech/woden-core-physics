"
I am a physics world that performs simulations by using discrete collision detection.
"
Class {
	#name : #WDPDiscreteDynamicPhysicsWorld,
	#superclass : #WDPPhysicsWorld,
	#instVars : [
		'gravity'
	],
	#category : #'WodenPhysics-Core-World'
}

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> computeBroadphaseCandidatePairs [
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
WDPDiscreteDynamicPhysicsWorld >> computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs [
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
WDPDiscreteDynamicPhysicsWorld >> detectAndResolveCollisionsWithDeltaTime: deltaTime [
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
WDPDiscreteDynamicPhysicsWorld >> detectNarrowphaseCollisionOf: firstCollisionObject with: secondCollisionObject [
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
WDPDiscreteDynamicPhysicsWorld >> gravity [

	^ gravity
]

{ #category : #accessing }
WDPDiscreteDynamicPhysicsWorld >> gravity: anObject [

	gravity := anObject
]

{ #category : #initialization }
WDPDiscreteDynamicPhysicsWorld >> initialize [
	super initialize.
	gravity := Vector3 zeros.
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> integrateMovementWithDeltaTime: deltaTime [
	collisionObjects do: [ :each | each integrateMovementWithDeltaTime: deltaTime ]
]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> resolveCollisionResponse: contactManifold [
	| firstCollisionObject secondCollisionObject inverseMassSum relativeVelocity restitutionCoefficient relativeVelocityAlongNormal impulse contactNormal penetrationDelta firstObjectHasResponse secondObjectHasResponse |
	firstCollisionObject := contactManifold firstCollisionObject.
	secondCollisionObject := contactManifold secondCollisionObject.
	firstObjectHasResponse := firstCollisionObject collisionResponseGroupMask anyMask: secondCollisionObject collisionGroup.
	secondObjectHasResponse := secondCollisionObject collisionResponseGroupMask anyMask: firstCollisionObject collisionGroup.
	(firstObjectHasResponse or: [secondObjectHasResponse]) ifFalse: [ ^ self ].
	
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].

	contactNormal := contactManifold normal.
	
	relativeVelocity := secondCollisionObject linearVelocity - firstCollisionObject linearVelocity.
	relativeVelocityAlongNormal := relativeVelocity dot: contactNormal.
	relativeVelocityAlongNormal <= 0.0 ifTrue: [ ^ self ].
	
	restitutionCoefficient := firstCollisionObject restitutionCoefficient * secondCollisionObject restitutionCoefficient.
	impulse := (restitutionCoefficient + 1.0) * relativeVelocityAlongNormal / inverseMassSum.
	
	firstObjectHasResponse ifTrue: [
		firstCollisionObject applyLinearImpulse: contactNormal * impulse
	].
	secondObjectHasResponse ifTrue: [
		secondCollisionObject applyLinearImpulse: contactNormal * impulse negated
	].
	
	penetrationDelta := contactManifold minimumTranslationVector / inverseMassSum.
	firstObjectHasResponse ifTrue: [ 
		firstCollisionObject translateBy: penetrationDelta * firstCollisionObject inverseMass
	].
	secondObjectHasResponse ifTrue: [
		secondCollisionObject translateBy: penetrationDelta * secondCollisionObject inverseMass negated
	].

]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactConstraints: contactManifold [
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]