"
I represent a single contact point in a contact manifold.
"
Class {
	#name : #WDPContactPoint,
	#superclass : #Object,
	#instVars : [
		'epoch',
		'normal',
		'requiredSeparation',
		'firstPoint',
		'secondPoint',
		'localFirstPoint',
		'localSecondPoint',
		'localFirstNormal',
		'localSecondNormal',
		'penetrationDistance'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

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
	localFirstNormal := firstTransform inverseTransformNormalVector: normal.
	localSecondNormal := secondTransform inverseTransformNormalVector: normal.
]

{ #category : #updating }
WDPContactPoint >> computeWorldContactPointAndDistances [
	penetrationDistance := requiredSeparation + (secondPoint - firstPoint dot: normal).
	
]

{ #category : #updating }
WDPContactPoint >> computeWorldVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	firstPoint := firstTransform transformPosition: localFirstPoint.
	secondPoint := secondTransform transformPosition: localSecondPoint.
	normal := firstTransform transformNormalVector: localFirstNormal.
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
		localFirstNormal: localSecondNormal negated;
		localSecondNormal: localFirstNormal negated;
		localFirstPoint: localSecondPoint;
		localSecondPoint: localFirstPoint;
		yourself
]

{ #category : #testing }
WDPContactPoint >> isSimilarTo: otherContact [
	^ (localFirstPoint closeTo: otherContact localFirstPoint) and: [ 
		(localSecondPoint closeTo: otherContact localSecondPoint)
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

{ #category : #accessing }
WDPContactPoint >> requiredSeparation [

	^ requiredSeparation
]

{ #category : #accessing }
WDPContactPoint >> requiredSeparation: anObject [

	requiredSeparation := anObject
]

{ #category : #accessing }
WDPContactPoint >> secondPoint [

	^ secondPoint
]

{ #category : #accessing }
WDPContactPoint >> secondPoint: anObject [

	secondPoint := anObject
]
