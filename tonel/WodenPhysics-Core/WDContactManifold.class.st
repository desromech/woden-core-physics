"
I encapsulate a contact manifold.
"
Class {
	#name : #WDContactManifold,
	#superclass : #Object,
	#instVars : [
		'normal',
		'penetrationDistance',
		'firstPoint',
		'secondPoint',
		'firstCollisionObject',
		'secondCollisionObject'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #accessing }
WDContactManifold >> firstCollisionObject [

	^ firstCollisionObject
]

{ #category : #accessing }
WDContactManifold >> firstCollisionObject: anObject [

	firstCollisionObject := anObject
]

{ #category : #accessing }
WDContactManifold >> firstPoint [

	^ firstPoint
]

{ #category : #accessing }
WDContactManifold >> firstPoint: anObject [

	firstPoint := anObject
]

{ #category : #properties }
WDContactManifold >> flipped [
	^ self copy
		normal: normal negated;
		firstPoint: secondPoint;
		secondPoint: firstPoint;
		yourself
]

{ #category : #accessing }
WDContactManifold >> minimumTranslationVector [
	^ normal * penetrationDistance
]

{ #category : #accessing }
WDContactManifold >> normal [

	^ normal
]

{ #category : #accessing }
WDContactManifold >> normal: anObject [

	normal := anObject
]

{ #category : #accessing }
WDContactManifold >> penetrationDistance [

	^ penetrationDistance
]

{ #category : #accessing }
WDContactManifold >> penetrationDistance: anObject [

	penetrationDistance := anObject
]

{ #category : #printing }
WDContactManifold >> printOn: aStream [
	aStream nextPutAll: 'normal: '; print: normal; nextPutAll: ' pd: '; print: penetrationDistance
]

{ #category : #accessing }
WDContactManifold >> secondCollisionObject [

	^ secondCollisionObject
]

{ #category : #accessing }
WDContactManifold >> secondCollisionObject: anObject [

	secondCollisionObject := anObject
]

{ #category : #accessing }
WDContactManifold >> secondPoint [

	^ secondPoint
]

{ #category : #accessing }
WDContactManifold >> secondPoint: anObject [

	secondPoint := anObject
]
