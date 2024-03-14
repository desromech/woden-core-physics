"
I am a rope constraint.
"
Class {
	#name : #WDPRopeConstraint,
	#superclass : #WDPPairObjectAnchoredUnionConstraint,
	#instVars : [
		'length'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #evaluation }
WDPRopeConstraint >> evaluateWithDeltaTime: deltaTime [
	| firstAnchorPoint secondAnchorPoint ropeVector ropeVectorLength deltaLength forceDirection force |
	firstAnchorPoint := self firstObjectAnchorPoint.
	secondAnchorPoint := self secondObjectAnchorPoint.
	ropeVector := firstAnchorPoint - secondAnchorPoint.
	ropeVectorLength := ropeVector length.
	ropeVectorLength <= length ifTrue: [ ^ self ].
	
	deltaLength := ropeVectorLength - length.
	forceDirection := ropeVector / ropeVectorLength.
	force := forceDirection negated * stiffness * deltaLength.

	firstObject applyForce: force inPosition: firstAnchorPoint.
	secondObject applyForce: force negated inPosition: secondAnchorPoint.
]

{ #category : #initialization }
WDPRopeConstraint >> initialize [
	super initialize.
	length := 1.0.
]

{ #category : #accessing }
WDPRopeConstraint >> length [

	^ length
]

{ #category : #accessing }
WDPRopeConstraint >> length: anObject [

	length := anObject
]
