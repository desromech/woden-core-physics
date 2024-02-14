"
I represent a single contact point in a contact manifold.
"
Class {
	#name : #WDPContactPoint,
	#superclass : #Object,
	#instVars : [
		'normal',
		'requiredSeparation',
		'point',
		'firstPoint',
		'secondPoint',
		'localFirstPoint',
		'localSecondPoint',
		'localNormal',
		'contactPoint',
		'penetrationDistance'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #updating }
WDPContactPoint >> computeLocalVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	localFirstPoint := firstTransform inverseTransformPosition: firstPoint.
	localSecondPoint := secondTransform inverseTransformPosition: secondPoint.
	localNormal := firstTransform inverseTransformNormalVector: normal.
]

{ #category : #updating }
WDPContactPoint >> computeWorldContactPointAndDistances [
	contactPoint := firstPoint + (secondPoint - firstPoint).
	penetrationDistance := (firstPoint - secondPoint dot: normal) + requiredSeparation max: 0.0.
]

{ #category : #updating }
WDPContactPoint >> computeWorldVersionWithFirstTransform: firstTransform secondTransform: secondTransform [
	firstPoint := firstTransform transformPosition: localFirstPoint.
	secondPoint := secondTransform transformPosition: localSecondPoint.
	normal := firstTransform transformNormalVector: localNormal.
	self computeWorldContactPointAndDistances.
]

{ #category : #accessing }
WDPContactPoint >> contactPoint [

	^ contactPoint
]

{ #category : #accessing }
WDPContactPoint >> contactPoint: anObject [

	contactPoint := anObject
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
		localNormal: localNormal negated;
		localFirstPoint: localSecondPoint;
		localSecondPoint: localFirstPoint;
		yourself
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
WDPContactPoint >> localNormal [

	^ localNormal
]

{ #category : #accessing }
WDPContactPoint >> localNormal: anObject [

	localNormal := anObject
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

	^ point
]

{ #category : #accessing }
WDPContactPoint >> point: anObject [

	point := anObject
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