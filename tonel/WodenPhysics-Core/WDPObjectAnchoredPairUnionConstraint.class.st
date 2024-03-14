"
I am a constraint which is used for joining a pair of objects on specific anchor points.
"
Class {
	#name : #WDPObjectAnchoredPairUnionConstraint,
	#superclass : #WDPObjectPairUnionConstraint,
	#instVars : [
		'firstObjectLocalAnchorPoint',
		'secondObjectLocalAnchorPoint'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> firstObjectAnchorPoint [
	^ firstObject
		ifNil: [firstObjectLocalAnchorPoint]
		ifNotNil: [firstObject transformLocalPosition: firstObjectLocalAnchorPoint]
]

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> firstObjectLocalAnchorPoint [

	^ firstObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> firstObjectLocalAnchorPoint: anObject [

	firstObjectLocalAnchorPoint := anObject
]

{ #category : #initialization }
WDPObjectAnchoredPairUnionConstraint >> initialize [
	super initialize.
	firstObjectLocalAnchorPoint := secondObjectLocalAnchorPoint := Vector3 zeros.
]

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> secondObjectAnchorPoint [
	^ secondObject
		ifNil: [ secondObjectLocalAnchorPoint ]
		ifNotNil: [ secondObject transformLocalPosition: secondObjectLocalAnchorPoint ]
]

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> secondObjectLocalAnchorPoint [

	^ secondObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPObjectAnchoredPairUnionConstraint >> secondObjectLocalAnchorPoint: anObject [

	secondObjectLocalAnchorPoint := anObject
]