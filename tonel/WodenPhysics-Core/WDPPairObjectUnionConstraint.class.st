"
I am a constraint which is used for joining a pair of objects on specific anchor points.
"
Class {
	#name : #WDPPairObjectUnionConstraint,
	#superclass : #WDPForceGeneratorConstraint,
	#instVars : [
		'stiffness',
		'firstObject',
		'firstObjectLocalAnchorPoint',
		'secondObject',
		'secondObjectLocalAnchorPoint'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObject [

	^ firstObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObject: anObject [

	firstObject := anObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObjectAnchorPoint [
	^ firstObject transform transformPosition: firstObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObjectLocalAnchorPoint [

	^ firstObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObjectLocalAnchorPoint: anObject [

	firstObjectLocalAnchorPoint := anObject
]

{ #category : #initialization }
WDPPairObjectUnionConstraint >> initialize [
	super initialize.
	stiffness := 50.0.
	firstObjectLocalAnchorPoint := secondObjectLocalAnchorPoint := Vector3 zeros.
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObject [

	^ secondObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObject: anObject [

	secondObject := anObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObjectAnchorPoint [
	^ secondObject transform transformPosition: secondObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObjectLocalAnchorPoint [

	^ secondObjectLocalAnchorPoint
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObjectLocalAnchorPoint: anObject [

	secondObjectLocalAnchorPoint := anObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> stiffness [

	^ stiffness
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> stiffness: anObject [

	stiffness := anObject
]
