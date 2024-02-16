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
	| firstCollisionObject secondCollisionObject restitutionCoefficient contactNormal  contactLocalToWorldMatrix3x3 relativeFirstPoint relativeSecondPoint firstContactVelocity secondContactVelocity relativeSeparationVelocity relativeContactSeparationVelocity deltaVelocity contactLocalImpulse contactImpulse contactLocalVelocityChange contactPoint relativeVelocityFromIntegrationDelta relativeContactVelocityFromIntegrationDelta planarImpulse staticFrictionCoefficient velocityChangePerImpulseWorldMatrix inverseMass velocityChangePerImpulseContactMatrix impulseChangePerVelocityContactMatrix |
	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	contact penetrationDistance <= 0.0 ifTrue: [ ^ self ].
	
	contactNormal := contact normal.
	contactPoint := contact point.

	relativeFirstPoint := contactPoint - firstCollisionObject position.
	relativeSecondPoint := contactPoint - secondCollisionObject position.

	contactLocalToWorldMatrix3x3 := contact computeContactSpaceMatrix.

	velocityChangePerImpulseWorldMatrix := 
	(firstCollisionObject computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativeFirstPoint) +
	(secondCollisionObject computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativeSecondPoint).
	
	velocityChangePerImpulseContactMatrix := contactLocalToWorldMatrix3x3 transpose * velocityChangePerImpulseWorldMatrix * contactLocalToWorldMatrix3x3.

	inverseMass := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	velocityChangePerImpulseContactMatrix := velocityChangePerImpulseContactMatrix + (Matrix3x3 scale: inverseMass).
	
	(velocityChangePerImpulseContactMatrix determinant closeTo: 0.0) ifTrue: [ ^ self ].
	impulseChangePerVelocityContactMatrix := velocityChangePerImpulseContactMatrix inverse.

	firstContactVelocity := firstCollisionObject velocityAtRelativePoint: relativeFirstPoint.
	secondContactVelocity := secondCollisionObject velocityAtRelativePoint: relativeSecondPoint.
	
	relativeSeparationVelocity := firstContactVelocity - secondContactVelocity.
	
	relativeContactSeparationVelocity := relativeSeparationVelocity * contactLocalToWorldMatrix3x3.
	relativeContactSeparationVelocity x > 0.0 ifTrue: [ ^ self ].

	relativeVelocityFromIntegrationDelta := firstCollisionObject linearVelocityIntegrationDelta - secondCollisionObject linearVelocityIntegrationDelta.
	relativeContactVelocityFromIntegrationDelta := relativeVelocityFromIntegrationDelta dot: contactNormal.
	
	restitutionCoefficient := firstCollisionObject restitutionCoefficient * secondCollisionObject restitutionCoefficient.
	
	"Resting contact: reduce contact velocity by acceleration only speed increase, and set the restitution coeffiecient to 0"
	relativeContactSeparationVelocity x abs < restingContactVelocityLimit ifTrue: [ 
		restitutionCoefficient := 0.0
	].

	deltaVelocity := relativeContactSeparationVelocity x negated - (restitutionCoefficient * (relativeContactSeparationVelocity x - relativeContactVelocityFromIntegrationDelta)).
	
	contactLocalVelocityChange := Vector3 x: deltaVelocity
		y: relativeContactSeparationVelocity y negated
		z: relativeContactSeparationVelocity z negated.
		
	contactLocalImpulse := impulseChangePerVelocityContactMatrix * contactLocalVelocityChange.

	"Compute the planar length for simulating friction."
	staticFrictionCoefficient := firstCollisionObject staticFrictionCoefficient min: secondCollisionObject staticFrictionCoefficient.
	planarImpulse := (contactLocalImpulse y squared + contactLocalImpulse z squared) sqrt.

	"Is this in the limits for the static friction?"
	planarImpulse > (contactLocalImpulse x * staticFrictionCoefficient) ifTrue: [
		| dynamicFrictionCoefficient frictionNormalDelta |
		dynamicFrictionCoefficient := firstCollisionObject dynamicFrictionCoefficient min: secondCollisionObject dynamicFrictionCoefficient.
		
		contactLocalImpulse y: contactLocalImpulse y / planarImpulse.
		contactLocalImpulse z: contactLocalImpulse z / planarImpulse.

		"contactLocalImpulse yz length = dynamicFrictionCoefficient * contactLocalImpulse x"
		
		"CHECK ME: What is the meaning of this correction? [From Millington Game Physics Engine Development, Chapter 15 pp 410]"
		frictionNormalDelta := velocityChangePerImpulseContactMatrix firstRow dot: (Vector3 x: 1 y: dynamicFrictionCoefficient*contactLocalImpulse y z: dynamicFrictionCoefficient*contactLocalImpulse z).
		contactLocalImpulse x: deltaVelocity / frictionNormalDelta.

		contactLocalImpulse y: contactLocalImpulse y * dynamicFrictionCoefficient * contactLocalImpulse x.
		contactLocalImpulse z: contactLocalImpulse z * dynamicFrictionCoefficient * contactLocalImpulse x.
	].

	contactImpulse := contactLocalToWorldMatrix3x3 * contactLocalImpulse.

	manifold firstObjectHasResponse ifTrue: [
		firstCollisionObject applyImpulse: contactImpulse inRelativePosition: relativeFirstPoint
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject applyImpulse: contactImpulse negated inRelativePosition: relativeSecondPoint
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifold: manifold contactConstraint: contact relaxationFactor: relaxationFactor [
	| firstCollisionObject secondCollisionObject inverseMassSum penetrationDistance penetrationDelta |
	penetrationDistance := contact penetrationDistance.
	penetrationDistance <= 0 ifTrue: [ ^ self ].

	firstCollisionObject := manifold firstCollisionObject.
	secondCollisionObject := manifold secondCollisionObject.
	
	inverseMassSum := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	inverseMassSum <= 0 ifTrue: [ ^ self ].
	
	penetrationDelta := contact normal * (penetrationDistance * relaxationFactor / inverseMassSum).
	manifold firstObjectHasResponse ifTrue: [ 
		firstCollisionObject translateBy: penetrationDelta * firstCollisionObject inverseMass
	].
	manifold secondObjectHasResponse ifTrue: [
		secondCollisionObject translateBy: penetrationDelta * secondCollisionObject inverseMass negated
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldCollisionResponse: contactManifold [
	contactManifold isEmpty ifTrue: [ ^ self ].
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactCollisionResponse: eachContact
	].

]

{ #category : #'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldConstraints: contactManifold relaxationFactor: relaxationFactor [
	contactManifold isEmpty ifTrue: [ ^ self ].
	(contactManifold firstObjectHasResponse or: [contactManifold secondObjectHasResponse]) ifFalse: [
		^ self
	].

	contactManifold updatingContactsDo: [ :eachContact |
		self resolveContactManifold: contactManifold contactConstraint: eachContact relaxationFactor: relaxationFactor
	].
]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldsCollisionsAndConstraints: contactManifolds [
	| numIterations relaxationFactor |
	numIterations := 2.
	1 to: numIterations do: [ :iteration |
		"Resolve the collision responses."
		contactManifolds do: [ :manifold |
			self resolveContactManifoldCollisionResponse: manifold
		].
	].
	
	"Resolve the contact constraints."
	relaxationFactor := 1.0.
	1 to: numIterations do: [ :iteration |
		contactManifolds do: [ :manifold |
			self resolveContactManifoldConstraints: manifold relaxationFactor: relaxationFactor.
		].
	].

]

{ #category : #update }
WDPDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime
]

{ #category : #enumerating }
WDPDiscreteDynamicPhysicsWorld >> worldSpaceContactPointsDo: aBlock [
	contactManifoldCache manifolds do: [ :eachManifold |
		eachManifold contactsDo: [:eachContact |
			aBlock cull: eachContact firstPoint cull: 1.
			aBlock cull: eachContact secondPoint cull: 2.
		]
	]
]
