"
I encapsulate a contact manifold.
"
Class {
	#name : #WDPContactManifold,
	#superclass : #Object,
	#instVars : [
		'pairId',
		'firstCollisionObject',
		'secondCollisionObject',
		'contacts'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPContactManifold >> contacts [

	^ contacts
]

{ #category : #accessing }
WDPContactManifold >> contacts: anObject [

	contacts := anObject
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
