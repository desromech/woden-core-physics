"
I encapsulate a contact manifold.
"
Class {
	#name : #WDContactManifold,
	#superclass : #Object,
	#instVars : [
		'normal',
		'penetrationDistance'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #properties }
WDContactManifold >> flipped [
	^ self copy normal: normal negated; yourself
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
