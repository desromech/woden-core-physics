"
I am a constraint which is used for joining a pair of objects on specific anchor points.
"
Class {
	#name : #WDPPairObjectAnchoredUnionConstraint,
	#superclass : #WDPPairObjectUnionConstraint,
	#instVars : [
		'firstObjectLocalAnchorPoint',
		'secondObjectLocalAnchorPoint'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> firstObjectAnchorPoint [
	^ firstObject transform transformPosition: firstObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> firstObjectLocalAnchorPoint [

	^ firstObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> firstObjectLocalAnchorPoint: anObject [

	firstObjectLocalAnchorPoint := anObject
]

{ #category : #initialization }
WDPPairObjectAnchoredUnionConstraint >> initialize [
	super initialize.
	firstObjectLocalAnchorPoint := secondObjectLocalAnchorPoint := Vector3 zeros.
]

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> secondObjectAnchorPoint [
	^ secondObject transform transformPosition: secondObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> secondObjectLocalAnchorPoint [

	^ secondObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectAnchoredUnionConstraint >> secondObjectLocalAnchorPoint: anObject [

	secondObjectLocalAnchorPoint := anObject
]
