"
I am a constraint that attempts to keep to objects with a specific relative position and relative orientation. I am used for modeling the situation where a hand is holding an object.
"
Class {
	#name : #WDPHoldObjectConstraint,
	#superclass : #WDPObjectPairUnionConstraint,
	#instVars : [
		'targetRelativePosition',
		'targetRelativeOrientation'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #evaluation }
WDPHoldObjectConstraint >> evaluateWithDeltaTime: deltaTime [
	| relativePosition relativeOrientation relativePositionDelta springForce |
	relativePosition := firstObject position - secondObject position.
	relativeOrientation := firstObject orientation * secondObject orientation inverse.
	
	Transcript show: 'relativePosition '; show: relativePosition; cr.
	Transcript show: 'relativeOrientation '; show: relativeOrientation; cr.
	
	relativePositionDelta := targetRelativePosition  - relativePosition.
	springForce := stiffness * relativePositionDelta.
	Transcript show: 'relativePositionDelta '; show: relativePositionDelta; cr.
	Transcript show: 'springForce '; show: springForce; cr.
	firstObject applyForce: springForce.
	secondObject applyForce: springForce negated.

]

{ #category : #initialization }
WDPHoldObjectConstraint >> initialize [
	super initialize.
	targetRelativePosition := Vector3 zeros.
	targetRelativeOrientation := Quaternion identity.
	
]

{ #category : #accessing }
WDPHoldObjectConstraint >> targetRelativeOrientation [

	^ targetRelativeOrientation
]

{ #category : #accessing }
WDPHoldObjectConstraint >> targetRelativeOrientation: anObject [

	targetRelativeOrientation := anObject
]

{ #category : #accessing }
WDPHoldObjectConstraint >> targetRelativePosition [

	^ targetRelativePosition
]

{ #category : #accessing }
WDPHoldObjectConstraint >> targetRelativePosition: anObject [

	targetRelativePosition := anObject
]
