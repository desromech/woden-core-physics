"
I am a physics world that performs simulations by using discrete collision detection.
"
Class {
	#name : 'WDPDiscreteDynamicPhysicsWorld',
	#superclass : 'WDPPhysicsWorld',
	#instVars : [
		'gravity'
	],
	#classVars : [
		'ImportanceConstraintSolvingThreshold'
	],
	#category : 'WodenPhysics-Core-World',
	#package : 'WodenPhysics-Core',
	#tag : 'World'
}

{ #category : 'class initialization' }
WDPDiscreteDynamicPhysicsWorld class >> initialize [
	ImportanceConstraintSolvingThreshold := 16.
]

{ #category : 'broadphase' }
WDPDiscreteDynamicPhysicsWorld >> computeBroadphaseCandidatePairs [
	| pairSet broadphasePairs |
	pairSet := Set new.	
	broadphasePairs := OrderedCollection new.
	awakeRigidBodies do: [ :each |
		each needsCollisionDetection ifTrue: [ 
			self findBroadphasePairsFor: each into: broadphasePairs pairSet: pairSet
		]
	].

	^ broadphasePairs
]

{ #category : 'narrowphase' }
WDPDiscreteDynamicPhysicsWorld >> computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs [
	contactManifoldCache beginEpoch.
	broadphaseCandidatePairs do: [ :each |
		self detectNarrowphaseCollisionOf: each first with: each second.
	].

	contactManifoldCache endEpoch.
	^ contactManifoldCache manifolds
]

{ #category : 'update' }
WDPDiscreteDynamicPhysicsWorld >> detectAndResolveCollisionsWithDeltaTime: deltaTime [
	| broadphaseCandidatePairs contactManifolds |
	broadphaseCandidatePairs := self computeBroadphaseCandidatePairs.
	contactManifolds := self computeNarrowPhaseConstantFromBroadphaseCandidatePairs: broadphaseCandidatePairs.
	self resolveContactManifoldsCollisionsAndConstraints: contactManifolds
]

{ #category : 'narrowphase' }
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

{ #category : 'update' }
WDPDiscreteDynamicPhysicsWorld >> evaluateForceGeneratorsWithDeltaTime: deltaTime [
	forceGenerators do: [ :each | each evaluateWithDeltaTime: deltaTime ]
]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> findMostSevereCollisionContactInList: contactList [
	| bestFound bestFoundClosingSpeed |
	contactList ifEmpty: [ ^ nil ].
	
	bestFound := nil.
	bestFoundClosingSpeed := Float negativeInfinity.
	
	contactList do: [ :contact |
		(contact hasCollisionResponse and: [contact inverseMass > 0.0]) ifTrue: [
			| closingSpeed |
			closingSpeed := contact closingSpeed.
			(bestFound isNil or: [closingSpeed > bestFoundClosingSpeed]) ifTrue: [ 
				bestFound := contact.
				bestFoundClosingSpeed := closingSpeed.
			]
		]
	].

	^ bestFound
]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> findMostSeverePenetrationContactInList: contactList [
	| bestFound |
	contactList ifEmpty: [ ^ nil ].
	
	bestFound := nil.
	contactList do: [ :contact |
		(contact hasCollisionResponse and: [ contact inverseMass > 0.0 ]) ifTrue: [
			contact update.
			(bestFound isNil or: [contact penetrationDistance > bestFound penetrationDistance]) ifTrue: [ 
				bestFound := contact
			]
		]
	].

	^ bestFound penetrationDistance >= 0
		ifTrue: [ bestFound ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
WDPDiscreteDynamicPhysicsWorld >> gravity [

	^ gravity
]

{ #category : 'accessing' }
WDPDiscreteDynamicPhysicsWorld >> gravity: anObject [

	gravity := anObject
]

{ #category : 'initialization' }
WDPDiscreteDynamicPhysicsWorld >> initialize [
	super initialize.
	gravity := Vector3 zeros.
]

{ #category : 'update' }
WDPDiscreteDynamicPhysicsWorld >> integrateMovementWithDeltaTime: deltaTime [
	awakeRigidBodies do: [ :each | each integrateMovementWithDeltaTime: deltaTime ]
]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactCollisionResponse: contact [
	"See Milling. 'Game Physics Engine Development'. Chapter 14 for details on these equations and the associated algorithms."
	| firstCollisionObject secondCollisionObject restitutionCoefficient contactNormal  contactLocalToWorldMatrix3x3 relativeFirstPoint relativeSecondPoint firstContactVelocity secondContactVelocity relativeSeparationVelocity relativeContactSeparationVelocity deltaVelocity contactLocalImpulse contactImpulse contactLocalVelocityChange relativeVelocityFromIntegrationDelta relativeContactVelocityFromIntegrationDelta planarImpulse staticFrictionCoefficient velocityChangePerImpulseWorldMatrix inverseMass velocityChangePerImpulseContactMatrix impulseChangePerVelocityContactMatrix |
	firstCollisionObject := contact firstCollisionObject.
	secondCollisionObject := contact secondCollisionObject.
	
	contactNormal := contact normal.

	relativeFirstPoint := contact relativeFirstPoint.
	relativeSecondPoint := contact relativeSecondPoint.

	contactLocalToWorldMatrix3x3 := contact computeContactSpaceMatrix.

	velocityChangePerImpulseWorldMatrix := 
	(firstCollisionObject computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativeFirstPoint) +
	(secondCollisionObject computeVelocityPerImpulseWorldMatrixForRelativeContactPoint: relativeSecondPoint).
	
	velocityChangePerImpulseContactMatrix := contactLocalToWorldMatrix3x3 transpose * velocityChangePerImpulseWorldMatrix * contactLocalToWorldMatrix3x3.

	inverseMass := firstCollisionObject inverseMass + secondCollisionObject inverseMass.
	velocityChangePerImpulseContactMatrix := velocityChangePerImpulseContactMatrix + (Matrix3x3 scale: inverseMass).
	
	(velocityChangePerImpulseContactMatrix determinant = 0) ifTrue: [ ^ self ].
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

	contact firstObjectHasResponse ifTrue: [
		firstCollisionObject applyImpulse: contactImpulse inRelativePosition: relativeFirstPoint
	].
	contact secondObjectHasResponse ifTrue: [
		secondCollisionObject applyImpulse: contactImpulse negated inRelativePosition: relativeSecondPoint
	].

]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactConstraint: contact relaxationFactor: relaxationFactor [
	| firstCollisionObject secondCollisionObject inverseInertia penetrationDistance penetrationDelta |
	contact hasCollisionResponse ifFalse: [ ^ self ].
	
	penetrationDistance := contact penetrationDistance.
	penetrationDistance <= 0 ifTrue: [ ^ self ].

	firstCollisionObject := contact firstCollisionObject.
	secondCollisionObject := contact secondCollisionObject.
	
	inverseInertia := contact inverseInertia.
	inverseInertia <= 0 ifTrue: [ ^ self ].
	
	penetrationDelta := penetrationDistance * relaxationFactor / inverseInertia.
	contact firstObjectHasResponse ifTrue: [ 
		firstCollisionObject applyMovement: penetrationDelta atRelativePoint: contact relativeFirstPoint withDirection: contact normal
	].
	contact secondObjectHasResponse ifTrue: [
		secondCollisionObject applyMovement: penetrationDelta atRelativePoint: contact relativeSecondPoint withDirection: contact normal negated
	].

]

{ #category : 'update' }
WDPDiscreteDynamicPhysicsWorld >> resolveContactManifoldsCollisionsAndConstraints: contactManifolds [
	| contactList contactIslands |
	contactIslands := self computeContactIslandsForManifolds: contactManifolds.
	contactList := OrderedCollection new.
	
	contactIslands do: [ :eachIsland |
		contactList removeAll.

		eachIsland do: [ :manifold |
			manifold hasCollisionResponse ifTrue: [ 
				contactList addAll: manifold contacts
			]
		].
		
		self solveCollisionContactResponseList: contactList.
		self solveCollisionContactConstraintList: contactList.		
	].


]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> solveCollisionContactConstraintList: contacts [
	| relaxationFactor iterationCount |
	relaxationFactor := 1.0.
	contacts size <= ImportanceConstraintSolvingThreshold ifTrue: [ 
		iterationCount := contacts size * 2.
		1 to: iterationCount do: [ :i |
			| contact | 
			contact := self findMostSeverePenetrationContactInList: contacts.
			contact ifNil: [ ^ self ].
	
			self resolveContactConstraint: contact relaxationFactor: relaxationFactor	
		].
	] ifFalse: [
		1 to: 2 do: [ :iteration |
			contacts do: [ :contact |
				contact update.
				self resolveContactConstraint: contact relaxationFactor: relaxationFactor				
			]
		]
	].

]

{ #category : 'constraint solving' }
WDPDiscreteDynamicPhysicsWorld >> solveCollisionContactResponseList: contacts [
	| iterationCount |
	contacts do: [ :eachContact | eachContact update ].
	
	contacts size <= ImportanceConstraintSolvingThreshold ifTrue: [
		iterationCount := contacts size * 2.
		1 to: iterationCount do: [ :i |
			| contact | 
			contact := self findMostSevereCollisionContactInList: contacts.
			contact ifNil: [ ^ self ].
	
			self resolveContactCollisionResponse: contact
		]
	] ifFalse: [
		1 to: 2 do: [ :iteration |
			contacts do: [ :contact |
				self resolveContactCollisionResponse: contact
			]
		]
	].

]

{ #category : 'update' }
WDPDiscreteDynamicPhysicsWorld >> updateWithDeltaTime: deltaTime [
	self
		evaluateForceGeneratorsWithDeltaTime: deltaTime;
		integrateMovementWithDeltaTime: deltaTime;
		detectAndResolveCollisionsWithDeltaTime: deltaTime;
		sendToSleepRestingObjects: deltaTime
]

{ #category : 'enumerating' }
WDPDiscreteDynamicPhysicsWorld >> worldSpaceContactPointsDo: aBlock [
	contactManifoldCache manifolds do: [ :eachManifold |
		eachManifold contacts do: [:eachContact |
			aBlock cull: eachContact firstPoint cull: 1.
			aBlock cull: eachContact secondPoint cull: 2.
		]
	]
]
