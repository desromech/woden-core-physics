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
		'contacts',
		'localLastSeparatingAxis'
	],
	#classVars : [
		'MaxSeparationTolerance'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #'class initialization' }
WDPContactManifold class >> initialize [
	MaxSeparationTolerance := 0.01.
]

{ #category : #adding }
WDPContactManifold >> addContact: newContact [
	localLastSeparatingAxis := newContact localFirstNormal.
	newContact firstCollisionObject: firstCollisionObject.
	newContact secondCollisionObject: secondCollisionObject.
	
	contacts doWithIndex: [ :eachExistingContact :index |
		(eachExistingContact isSimilarTo: newContact) ifTrue: [ 
			contacts at: index put: newContact.
			^ self
		].
	].

	contacts add: newContact
]

{ #category : #adding }
WDPContactManifold >> addContacts: newContacts [
	newContacts do: [ :each | self addContact: each ].
]

{ #category : #accessing }
WDPContactManifold >> contactIslandRoot [
	firstCollisionObject participatesInContactResolution ifTrue: [ ^ firstCollisionObject getContactIslandRoot ].
	secondCollisionObject participatesInContactResolution ifTrue: [ ^ secondCollisionObject getContactIslandRoot ].
	^ nil
]

{ #category : #accessing }
WDPContactManifold >> contacts [

	^ contacts
]

{ #category : #accessing }
WDPContactManifold >> contacts: anObject [

	contacts := anObject
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
WDPContactManifold >> expireContactsUntil: oldestEpoch for: newEpoch [
	contacts do: [ :each |
		each update.
	].
	contacts removeAllSuchThat: [:each |
		(each penetrationDistance negated > MaxSeparationTolerance) or: [each epoch < oldestEpoch]
	]
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

{ #category : #testing }
WDPContactManifold >> hasCollisionResponse [
	^ self firstObjectHasResponse or: [ self secondObjectHasResponse ]
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
	^ localLastSeparatingAxis ifNotNil: [ firstCollisionObject transform transformNormalVector: (secondCollisionObject transform transformNormalVector: localLastSeparatingAxis) ]
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
WDPContactManifold >> update [
	contacts do: [ :each | each update ].

]
