"
I encapsulate a contact manifold.
"
Class {
	#name : #WDPContactManifold,
	#superclass : #Object,
	#instVars : [
		'pairId',
		'epoch',
		'firstCollisionObject',
		'secondCollisionObject',
		'contacts'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #adding }
WDPContactManifold >> addContact: newContact [
	contacts do: [ :eachExistingContact |
		(eachExistingContact isSimilarTo: newContact) ifTrue: [ 
			eachExistingContact epoch: (eachExistingContact epoch max: newContact epoch).
			^ self
		].
	].

	contacts add: newContact
]

{ #category : #adding }
WDPContactManifold >> addContacts: newContacts [
	newContacts do: [ :each | self addContact: each ].
]

{ #category : #update }
WDPContactManifold >> contactsDo: aBlock [
	contacts do: aBlock

]

{ #category : #accessing }
WDPContactManifold >> epoch [

	^ epoch
]

{ #category : #accessing }
WDPContactManifold >> epoch: anObject [

	epoch := anObject
]

{ #category : #update }
WDPContactManifold >> expireContactsUntil: oldestEpoch [
	contacts removeAllSuchThat: [:each | each epoch < oldestEpoch ]
]

{ #category : #accessing }
WDPContactManifold >> firstCollisionObject [

	^ firstCollisionObject
]

{ #category : #accessing }
WDPContactManifold >> firstCollisionObject: anObject [

	firstCollisionObject := anObject
]

{ #category : #testing }
WDPContactManifold >> firstObjectHasResponse [
	^ firstCollisionObject collisionResponseGroupMask anyMask: secondCollisionObject collisionGroup
]

{ #category : #initialization }
WDPContactManifold >> initialize [
	super initialize.
	contacts := OrderedCollection new.
]

{ #category : #testing }
WDPContactManifold >> isEmpty [
	^ contacts isEmpty
]

{ #category : #accessing }
WDPContactManifold >> lastSeparatingAxis [
	^ contacts isEmpty
		ifTrue: [ nil ]
		ifFalse: [ firstCollisionObject transform transformNormalVector: contacts last localFirstNormal ]
]

{ #category : #accessing }
WDPContactManifold >> pairId [

	^ pairId
]

{ #category : #accessing }
WDPContactManifold >> pairId: anObject [

	pairId := anObject
]

{ #category : #accessing }
WDPContactManifold >> secondCollisionObject [

	^ secondCollisionObject
]

{ #category : #accessing }
WDPContactManifold >> secondCollisionObject: anObject [

	secondCollisionObject := anObject
]

{ #category : #testing }
WDPContactManifold >> secondObjectHasResponse [
	^ secondCollisionObject collisionResponseGroupMask anyMask: firstCollisionObject collisionGroup
]

{ #category : #testing }
WDPContactManifold >> size [
	^ contacts size
]

{ #category : #update }
WDPContactManifold >> updateContacts [
	| firstTransform secondTransform |
	firstTransform := firstCollisionObject transform.
	secondTransform := secondCollisionObject transform.
	contacts do: [ :each |
		each computeWorldVersionWithFirstTransform: firstTransform secondTransform:   secondTransform
	].

]

{ #category : #update }
WDPContactManifold >> updatingContactsDo: aBlock [
	| firstTransform secondTransform |
	firstTransform := firstCollisionObject transform.
	secondTransform := secondCollisionObject transform.
	contacts do: [ :each |
		each computeWorldVersionWithFirstTransform: firstTransform secondTransform: secondTransform.
		aBlock value: each
	].

]
