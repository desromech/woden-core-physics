"
I am a constraint that attempts to keep to objects with a specific relative position and relative orientation.
"
Class {
	#name : #WDPRelativeTransformUnionConstraint,
	#superclass : #WDPPairObjectUnionConstraint,
	#instVars : [
		'targetRelativePosition',
		'targetRelativeOrientation'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #evaluation }
WDPRelativeTransformUnionConstraint >> evaluateWithDeltaTime: deltaTime [
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
WDPRelativeTransformUnionConstraint >> initialize [
	super initialize.
	targetRelativePosition := Vector3 zeros.
	targetRelativeOrientation := Quaternion identity.
	
]

{ #category : #accessing }
WDPRelativeTransformUnionConstraint >> targetRelativeOrientation [

	^ targetRelativeOrientation
]

{ #category : #accessing }
WDPRelativeTransformUnionConstraint >> targetRelativeOrientation: anObject [

	targetRelativeOrientation := anObject
]

{ #category : #accessing }
WDPRelativeTransformUnionConstraint >> targetRelativePosition [

	^ targetRelativePosition
]

{ #category : #accessing }
WDPRelativeTransformUnionConstraint >> targetRelativePosition: anObject [

	targetRelativePosition := anObject
]
