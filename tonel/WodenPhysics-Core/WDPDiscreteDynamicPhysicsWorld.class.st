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
		self resolveContactManifoldCollisionResponse: contact
	].
	
	"Resolve the contact constraints."
	narrowPhaseContacts do: [ :contact |
		self resolveContactManifoldConstraints: contact
	].

]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> detectNarrowphaseCollisionOf: firstCollisionObject with: secondCollisionObject [
	| firstShape firstTransform secondShape secondTransform contactPoints |
	firstShape := firstCollisionObject shape.
	firstTransform := firstCollisionObject transform.
	secondShape := secondCollisionObject shape.
	secondTransform := secondCollisionObject transform.
	
	contactPoints := firstShape detectAndComputeCollisionContactPointsAt: firstTransform with: secondShape at: secondTransform.
	contactPoints ifEmpty: [ ^ nil ].
	
	^ WDPContactManifold new
		firstCollisionObject: firstCollisionObject;
		secondCollisionObject: secondCollisionObject;
		contacts: contactPoints;
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
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifold: manifold contactCollisionResponse: contact [
	| firstCollisionObject secondCollisionObject inverseMassSum restitutionCoefficient contactNormal relativeVelocity relativeVelocityAlongNormal impulse |
	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].
	
	restitutionCoefficient := firstCollisionObject restitutionCoefficient * secondCollisionObject restitutionCoefficient.
	
	contactNormal := contact normal.
	
	relativeVelocity := secondCollisionObject linearVelocity - firstCollisionObject linearVelocity.
	relativeVelocityAlongNormal := relativeVelocity dot: contactNormal.
	relativeVelocityAlongNormal <= 0.0 ifTrue: [ ^ self ].
	
	impulse := (restitutionCoefficient + 1.0) * relativeVelocityAlongNormal / inverseMassSum.
	
	manifold firstObjectHasResponse ifTrue: [
		firstCollisionObject applyLinearImpulse: contactNormal * impulse
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject applyLinearImpulse: contactNormal * impulse negated
	].

]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifold: manifold contactConstraint: contact [
	| firstCollisionObject secondCollisionObject inverseMassSum penetrationDistance penetrationDelta |
	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].
	
	penetrationDistance := contact penetrationDistance.
	penetrationDistance <= 0 ifTrue: [ ^ self ].
	
	penetrationDelta := contact normal * (penetrationDistance / inverseMassSum).
	manifold firstObjectHasResponse ifTrue: [ 
		firstCollisionObject translateBy: penetrationDelta * firstCollisionObject inverseMass
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject translateBy: penetrationDelta * secondCollisionObject inverseMass negated
	].

]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldCollisionResponse: contactManifold [
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactCollisionResponse: eachContact
	].

]

{ #category : #'as yet unclassified' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldConstraints: contactManifold [
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactConstraint: eachContact
	].
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]
