"
I encapsulate a contact manifold.
"
Class {
	#name : #WDPContactManifold,
	#superclass : #Object,
	#instVars : [
		'normal',
		'penetrationDistance',
		'firstPoint',
		'secondPoint',
		'firstCollisionObject',
		'secondCollisionObject'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPContactManifold >> firstCollisionObject [

	^ firstCollisionObject
]

{ #category : #accessing }
WDPContactManifold >> firstCollisionObject: anObject [

	firstCollisionObject := anObject
]

{ #category : #accessing }
WDPContactManifold >> firstPoint [

	^ firstPoint
]

{ #category : #accessing }
WDPContactManifold >> firstPoint: anObject [

	firstPoint := anObject
]

{ #category : #properties }
WDPContactManifold >> flipped [
	^ self copy
		normal: normal negated;
		firstPoint: secondPoint;
		secondPoint: firstPoint;
		yourself
]

{ #category : #accessing }
WDPContactManifold >> minimumTranslationVector [
	^ normal * penetrationDistance
]

{ #category : #accessing }
WDPContactManifold >> normal [

	^ normal
]

{ #category : #accessing }
WDPContactManifold >> normal: anObject [

	normal := anObject
]

{ #category : #accessing }
WDPContactManifold >> penetrationDistance [

	^ penetrationDistance
]

{ #category : #accessing }
WDPContactManifold >> penetrationDistance: anObject [

	penetrationDistance := anObject
]

{ #category : #printing }
WDPContactManifold >> printOn: aStream [
	aStream nextPutAll: 'normal: '; print: normal; nextPutAll: ' pd: '; print: penetrationDistance
]

{ #category : #accessing }
WDPContactManifold >> secondCollisionObject [

	^ secondCollisionObject
]

{ #category : #accessing }
WDPContactManifold >> secondCollisionObject: anObject [

	secondCollisionObject := anObject
]

{ #category : #accessing }
WDPContactManifold >> secondPoint [

	^ secondPoint
]

{ #category : #accessing }
WDPContactManifold >> secondPoint: anObject [

	secondPoint := anObject
]
