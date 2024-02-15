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

{ #category : #broadphase }
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

{ #category : #narrowphase }
WDPDiscreteDynamicPhysicsWorld >> computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs [
	contactManifoldCache beginEpoch.
	broadphaseCandidatePairs do: [ :each |
		self detectNarrowphaseCollisionOf: each first with: each second.
	].

	contactManifoldCache endEpoch.
	^ contactManifoldCache manifolds
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> detectAndResolveCollisionsWithDeltaTime: deltaTime [
	| broadphaseCandidatePairs contactManifolds |
	broadphaseCandidatePairs := self computeBroadphaseCandidatePairs.
	contactManifolds := self computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs.
	self resolveContactManifoldsCollisionsAndConstraints: contactManifolds
]

{ #category : #narrowphase }
WDPDiscreteDynamicPhysicsWorld >> detectNarrowphaseCollisionOf: firstCollisionObject with: secondCollisionObject [
	| firstShape firstTransform secondShape secondTransform contactPoints separatingAxisHint |
	firstShape := firstCollisionObject shape.
	firstTransform := firstCollisionObject transform.
	secondShape := secondCollisionObject shape.
	secondTransform := secondCollisionObject transform.
	separatingAxisHint := contactManifoldCache lastSeparatingAxisFor: firstCollisionObject with: secondCollisionObject.
	separatingAxisHint ifNil: [ 
		separatingAxisHint := (secondTransform translation - firstTransform translation) normalized.
		(separatingAxisHint closeTo: Vector3 zeros) ifTrue: [ 
			separatingAxisHint := nil
		]
	].
	
	contactPoints := firstShape detectAndComputeCollisionContactPointsAt: firstTransform with: secondShape at: secondTransform separatingAxisHint: separatingAxisHint.
	contactManifoldCache insertContacts: contactPoints for: firstCollisionObject with: secondCollisionObject.
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

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifold: manifold contactCollisionResponse: contact [
	"See Milling. 'Game Physics Engine Development'. Chapter 14 for details on these equations and the associated algorithms."
	| firstCollisionObject secondCollisionObject restitutionCoefficient contactNormal  contactLocalToWorldMatrix3x3 relativeFirstPoint relativeSecondPoint firstContactVelocity secondContactVelocity relativeSeparationVelocity relativeContactSeparationVelocity deltaVelocity contactLocalImpulse contactImpulse contactLocalVelocityChange firstVelocityChangePerImpulseWorld secondVelocityChangePerImpulseWorld velocityChangePerImpulse |
	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	contactNormal := contact normal.

	relativeFirstPoint := contact firstPoint - firstCollisionObject position.
	relativeSecondPoint := contact secondPoint - secondCollisionObject position.

	contactLocalToWorldMatrix3x3 := contact computeContactSpaceMatrix.

	"Torque per unit impulse."
	firstVelocityChangePerImpulseWorld := relativeFirstPoint cross: contactNormal.
	"Rotation per unit impulse."
	firstVelocityChangePerImpulseWorld := firstCollisionObject worldInverseInertiaTensor * firstVelocityChangePerImpulseWorld.
	"Velocity per unit impulse."
	firstVelocityChangePerImpulseWorld := firstVelocityChangePerImpulseWorld cross: relativeFirstPoint.

	"Torque per unit impulse."
	secondVelocityChangePerImpulseWorld := relativeSecondPoint cross: contactNormal.
	"Rotation per unit impulse."
	secondVelocityChangePerImpulseWorld := secondCollisionObject worldInverseInertiaTensor * secondVelocityChangePerImpulseWorld.
	"Velocity per unit impulse."
	secondVelocityChangePerImpulseWorld := secondVelocityChangePerImpulseWorld cross: relativeSecondPoint.
	
	velocityChangePerImpulse :=
		firstCollisionObject inverseMass + (firstVelocityChangePerImpulseWorld dot: contactNormal) +
		secondCollisionObject inverseMass + (secondVelocityChangePerImpulseWorld dot: contactNormal).
	velocityChangePerImpulse <= 0 ifTrue: [ ^ self ].

	firstContactVelocity := firstCollisionObject linearVelocity + (firstCollisionObject angularVelocity cross: relativeFirstPoint).
	secondContactVelocity := secondCollisionObject linearVelocity + (secondCollisionObject angularVelocity cross: relativeSecondPoint).
	
	relativeSeparationVelocity := firstContactVelocity - secondContactVelocity.
	relativeContactSeparationVelocity := relativeSeparationVelocity * contactLocalToWorldMatrix3x3.
	relativeContactSeparationVelocity x > 0.0 ifTrue: [ ^ self ].
	
	restitutionCoefficient := firstCollisionObject restitutionCoefficient * secondCollisionObject restitutionCoefficient.

	deltaVelocity := (restitutionCoefficient + 1.0) * relativeContactSeparationVelocity x negated.
	
	contactLocalVelocityChange := Vector3 x: deltaVelocity.
	contactLocalImpulse := contactLocalVelocityChange / velocityChangePerImpulse.
	contactImpulse := contactLocalToWorldMatrix3x3 * contactLocalImpulse.
	
	manifold firstObjectHasResponse ifTrue: [
		firstCollisionObject applyImpulse: contactImpulse inRelativePosition: relativeFirstPoint
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject applyImpulse: contactImpulse negated inRelativePosition: relativeSecondPoint
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifold: manifold contactConstraint: contact [
	| firstCollisionObject secondCollisionObject inverseMassSum penetrationDistance penetrationDelta |
	penetrationDistance := contact penetrationDistance.
	penetrationDistance <= 0 ifTrue: [ ^ self ].

	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].
	
	penetrationDelta := contact normal * (penetrationDistance / inverseMassSum).
	manifold firstObjectHasResponse ifTrue: [ 
		firstCollisionObject translateBy: penetrationDelta * firstCollisionObject inverseMass
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject translateBy: penetrationDelta * secondCollisionObject inverseMass negated
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldCollisionResponse: contactManifold [
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactCollisionResponse: eachContact
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldConstraints: contactManifold [
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactConstraint: eachContact
	].
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldsCollisionsAndConstraints: contactManifolds [
	| numIterations |
	numIterations := 1.
	1 to: numIterations do: [ :iteration |
		"Resolve the collision responses."
		contactManifolds do: [ :contact |
			self resolveContactManifoldCollisionResponse: contact
		].
	].
	
	"Resolve the contact constraints."
	1 to: numIterations do: [ :iteration |
		contactManifolds do: [ :contact |
			self resolveContactManifoldConstraints: contact
		].
	].

]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]
