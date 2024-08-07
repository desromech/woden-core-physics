"
I am a rod constraint.
"
Class {
	#name : 'WDPRodConstraint',
	#superclass : 'WDPObjectAnchoredPairUnionConstraint',
	#instVars : [
		'length'
	],
	#category : 'WodenPhysics-Core-Constraints',
	#package : 'WodenPhysics-Core',
	#tag : 'Constraints'
}

{ #category : 'evaluation' }
WDPRodConstraint >> evaluateWithDeltaTime: deltaTime [
	| firstAnchorPoint secondAnchorPoint ropeVector ropeVectorLength deltaLength forceDirection force |
	firstAnchorPoint := self firstObjectAnchorPoint.
	secondAnchorPoint := self secondObjectAnchorPoint.
	ropeVector := firstAnchorPoint - secondAnchorPoint.
	ropeVectorLength := ropeVector length.
	ropeVectorLength <= 0.0 ifTrue: [ ^ self ].
	
	deltaLength := ropeVectorLength - length.
	forceDirection := ropeVector / ropeVectorLength.
	force := forceDirection negated * stiffness * deltaLength.
	
	firstObject ifNotNil: [
		firstObject applyForce: force inPosition: firstAnchorPoint.
	].
	secondObject ifNotNil: [ 	
		secondObject applyForce: force negated inPosition: secondAnchorPoint
	].
]

{ #category : 'initialization' }
WDPRodConstraint >> initialize [
	super initialize.
	length := 1.0.
]

{ #category : 'accessing' }
WDPRodConstraint >> length [

	^ length
]

{ #category : 'accessing' }
WDPRodConstraint >> length: anObject [

	length := anObject
]
