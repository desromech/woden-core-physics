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
	| targetPosition relativePositionDelta springForce dampingForce targetVelocity |
	targetPosition := firstObject transformPositionToWorld: targetRelativePosition.
	
	relativePositionDelta := targetPosition - secondObject position.
	targetVelocity := firstObject linearVelocity - secondObject linearVelocity.
	springForce := relativePositionDelta * stiffness.
	dampingForce := targetVelocity * damping.
	secondObject applyForce: springForce + dampingForce.

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
