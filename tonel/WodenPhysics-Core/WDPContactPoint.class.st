"
I represent a single contact point in a contact manifold.
"
Class {
	#name : #WDPContactPoint,
	#superclass : #Object,
	#instVars : [
		'epoch',
		'normal',
		'firstCollisionObject',
		'secondCollisionObject',
		'requiredSeparation',
		'firstPoint',
		'secondPoint',
		'localFirstPoint',
		'localSecondPoint',
		'localFirstNormal',
		'localSecondNormal',
		'penetrationDistance'
	],
	#classVars : [
		'PointEpsilon'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #'class initialization' }
WDPContactPoint class >> initialize [
	PointEpsilon := 0.001.
]

{ #category : #accessing }
WDPContactPoint >> closingSpeed [
	^ self separationSpeed negated
]

{ #category : #'contact resolution' }
WDPContactPoint >> computeContactSpaceMatrix [
	| x y z |
	x := normal.
	y := normal x abs > normal y abs
		ifTrue: [ Vector3 y: 1]
		ifFalse: [ Vector3 x: 1 ].

	z := (x cross: y) normalized.
	y := (z cross: x) normalized.
	
	^ Matrix3x3 columns: { x . y . z }

]

{ #category : #updating }
WDPContactPoint >> computeLocalVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	localFirstPoint := firstTransform inverseTransformPosition: firstPoint.
	localSecondPoint := secondTransform inverseTransformPosition: secondPoint.
	localFirstNormal := firstTransform inverseTransformNormalVector: (secondTransform inverseTransformNormalVector: normal).
	localSecondNormal := secondTransform inverseTransformNormalVector: (firstTransform inverseTransformNormalVector: normal negated).
]

{ #category : #updating }
WDPContactPoint >> computeWorldContactPointAndDistances [
	penetrationDistance := requiredSeparation + (secondPoint - firstPoint dot: normal).
	
]

{ #category : #updating }
WDPContactPoint >> computeWorldVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	firstPoint := firstTransform transformPosition: localFirstPoint.
	secondPoint := secondTransform transformPosition: localSecondPoint.
	normal := firstTransform transformNormalVector: (secondTransform transformNormalVector: localFirstNormal).
	self computeWorldContactPointAndDistances.
]

{ #category : #accessing }
WDPContactPoint >> epoch [

	^ epoch
]

{ #category : #accessing }
WDPContactPoint >> epoch: anObject [

	epoch := anObject
]

{ #category : #accessing }
WDPContactPoint >> firstCollisionObject [

	^ firstCollisionObject
]

{ #category : #accessing }
WDPContactPoint >> firstCollisionObject: anObject [

	firstCollisionObject := anObject
]

{ #category : #accessing }
WDPContactPoint >> firstObjectHasResponse [
	^ firstCollisionObject collisionResponseGroupMask anyMask: secondCollisionObject collisionGroup
]

{ #category : #accessing }
WDPContactPoint >> firstPoint [

	^ firstPoint
]

{ #category : #accessing }
WDPContactPoint >> firstPoint: anObject [

	firstPoint := anObject
]

{ #category : #updating }
WDPContactPoint >> flipped [
	^ self copy
		normal: normal negated;
		firstPoint: secondPoint;
		secondPoint: firstPoint;
		localFirstNormal: localSecondNormal;
		localSecondNormal: localFirstNormal;
		localFirstPoint: localSecondPoint;
		localSecondPoint: localFirstPoint;
		yourself
]

{ #category : #testing }
WDPContactPoint >> hasCollisionResponse [
	^ self firstObjectHasResponse or: [self secondObjectHasResponse]
]

{ #category : #accessing }
WDPContactPoint >> inverseAngularInertia [
	^ (firstCollisionObject computeAngularInertiaForRelativeContactPoint: self relativeFirstPoint normal: normal) + (secondCollisionObject computeAngularInertiaForRelativeContactPoint: self relativeFirstPoint normal: normal)
]

{ #category : #accessing }
WDPContactPoint >> inverseInertia [
	^ self inverseLinearInertia + self inverseAngularInertia
]

{ #category : #accessing }
WDPContactPoint >> inverseLinearInertia [
	^ firstCollisionObject inverseMass + secondCollisionObject inverseMass
]

{ #category : #accessing }
WDPContactPoint >> inverseMass [
	^ firstCollisionObject inverseMass + secondCollisionObject inverseMass
]

{ #category : #testing }
WDPContactPoint >> isSimilarTo: otherContact [
	^ (localFirstPoint closeTo: otherContact localFirstPoint precision: PointEpsilon) and: [ 
		(localSecondPoint closeTo: otherContact localSecondPoint precision: PointEpsilon)
	]
]

{ #category : #accessing }
WDPContactPoint >> localFirstNormal [

	^ localFirstNormal
]

{ #category : #accessing }
WDPContactPoint >> localFirstNormal: anObject [

	localFirstNormal := anObject
]

{ #category : #accessing }
WDPContactPoint >> localFirstPoint [

	^ localFirstPoint
]

{ #category : #accessing }
WDPContactPoint >> localFirstPoint: anObject [

	localFirstPoint := anObject
]

{ #category : #accessing }
WDPContactPoint >> localSecondNormal [

	^ localSecondNormal
]

{ #category : #accessing }
WDPContactPoint >> localSecondNormal: anObject [

	localSecondNormal := anObject
]

{ #category : #accessing }
WDPContactPoint >> localSecondPoint [

	^ localSecondPoint
]

{ #category : #accessing }
WDPContactPoint >> localSecondPoint: anObject [

	localSecondPoint := anObject
]

{ #category : #accessing }
WDPContactPoint >> normal [

	^ normal
]

{ #category : #accessing }
WDPContactPoint >> normal: anObject [

	normal := anObject
]

{ #category : #accessing }
WDPContactPoint >> penetrationDistance [

	^ penetrationDistance
]

{ #category : #accessing }
WDPContactPoint >> penetrationDistance: anObject [

	penetrationDistance := anObject
]

{ #category : #accessing }
WDPContactPoint >> point [
	^ firstPoint + ((secondPoint - firstPoint) * 0.5)
]

{ #category : #printing }
WDPContactPoint >> printOn: aStream [
	aStream nextPutAll: 'normal: '; print: normal; nextPutAll: ' pd: '; print: penetrationDistance
]

{ #category : #'as yet unclassified' }
WDPContactPoint >> relativeFirstPoint [
	^ firstPoint - firstCollisionObject position
]

{ #category : #'as yet unclassified' }
WDPContactPoint >> relativeSecondPoint [
	^ secondPoint - secondCollisionObject position
]

{ #category : #accessing }
WDPContactPoint >> requiredSeparation [

	^ requiredSeparation
]

{ #category : #accessing }
WDPContactPoint >> requiredSeparation: anObject [

	requiredSeparation := anObject
]

{ #category : #accessing }
WDPContactPoint >> secondCollisionObject [

	^ secondCollisionObject
]

{ #category : #accessing }
WDPContactPoint >> secondCollisionObject: anObject [

	secondCollisionObject := anObject
]

{ #category : #accessing }
WDPContactPoint >> secondObjectHasResponse [
	^ secondCollisionObject collisionResponseGroupMask anyMask: firstCollisionObject collisionGroup
]

{ #category : #accessing }
WDPContactPoint >> secondPoint [

	^ secondPoint
]

{ #category : #accessing }
WDPContactPoint >> secondPoint: anObject [

	secondPoint := anObject
]

{ #category : #accessing }
WDPContactPoint >> separationSpeed [
	^ (firstCollisionObject velocityAtRelativePoint: self relativeFirstPoint) - (secondCollisionObject velocityAtRelativePoint: self relativeSecondPoint) dot: normal
]

{ #category : #accessing }
WDPContactPoint >> totalInverseInertia [
	^ self inverseLinearInertia + self inverseAngularInertia
]

{ #category : #updating }
WDPContactPoint >> update [
	self computeWorldVersionWithFirstTransform: firstCollisionObject transform secondTransform: secondCollisionObject transform
]
