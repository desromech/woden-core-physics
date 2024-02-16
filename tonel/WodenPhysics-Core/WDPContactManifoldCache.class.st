"
I am a cache of contact manifolds.
"
Class {
	#name : #WDPContactManifoldCache,
	#superclass : #Object,
	#instVars : [
		'manifolds',
		'epoch',
		'manifoldDictionary'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #defaults }
WDPContactManifoldCache class >> defaultOldestKeptEpoch [
	^ 8
]

{ #category : #updating }
WDPContactManifoldCache >> beginEpoch [
	epoch := epoch + 1
]

{ #category : #private }
WDPContactManifoldCache >> composeCollisionId: firstId with: secondId [
	self assert: firstId < secondId.
	^ firstId | (secondId << 32)
]

{ #category : #updating }
WDPContactManifoldCache >> endEpoch [
	| expiredEpoch keptManifolds |
	expiredEpoch := epoch - self class defaultOldestKeptEpoch.
	keptManifolds := OrderedCollection new.
	manifolds do: [ :each |
		each expireContactsUntil: expiredEpoch for: epoch.
		
		(each epoch >= expiredEpoch and: [each contacts isNotEmpty]) ifTrue: [
			keptManifolds add: each.
		] ifFalse: [ 
			manifoldDictionary removeKey: each pairId
		]
	].

	manifolds := keptManifolds
]

{ #category : #private }
WDPContactManifoldCache >> getOrCreateManifoldFor: firstCollisionObject with: secondCollisionObject [
	| pairId manifold |
	pairId := self composeCollisionId: firstCollisionObject id with: secondCollisionObject id.
	manifold := manifoldDictionary at: pairId ifAbsentPut: [
		| newManifold |
		newManifold := (WDPContactManifold new
			pairId: pairId;
			firstCollisionObject: firstCollisionObject;
			secondCollisionObject: secondCollisionObject;
			yourself).
		manifolds add: newManifold.
		newManifold
	].
	
	manifold epoch: epoch.
	^ manifold
]

{ #category : #initialization }
WDPContactManifoldCache >> initialize [
	super initialize.
	manifolds := OrderedCollection new.
	manifoldDictionary := Dictionary new.
	epoch := 0.
]

{ #category : #adding }
WDPContactManifoldCache >> insertContacts: contactPoints for: firstCollisionObject with: secondCollisionObject [
	contactPoints ifEmpty: [ ^ self ].

	contactPoints do: [ :each | each epoch: epoch ].
	(self getOrCreateManifoldFor: firstCollisionObject with: secondCollisionObject)	
		addContacts: contactPoints

]

{ #category : #adding }
WDPContactManifoldCache >> lastSeparatingAxisFor: firstCollisionObject with: secondCollisionObject [
	^ manifoldDictionary at: (self composeCollisionId: firstCollisionObject id with: secondCollisionObject id)
		ifPresent: [:manifold | manifold lastSeparatingAxis ]
		ifAbsent: [ nil ]
]

{ #category : #accessing }
WDPContactManifoldCache >> manifolds [
	^ manifolds
]
