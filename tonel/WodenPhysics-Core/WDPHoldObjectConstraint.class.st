"
I am a constraint that attempts to keep to objects with a specific relative position and relative orientation. I am used for modeling the situation where a hand is holding an object.
"
Class {
	#name : 'WDPHoldObjectConstraint',
	#superclass : 'WDPObjectPairUnionConstraint',
	#instVars : [
		'targetRelativePosition',
		'targetRelativeOrientation'
	],
	#category : 'WodenPhysics-Core-Constraints',
	#package : 'WodenPhysics-Core',
	#tag : 'Constraints'
}

{ #category : 'evaluation' }
WDPHoldObjectConstraint >> evaluateWithDeltaTime: deltaTime [
	| targetPosition targetOrientation relativePositionDelta springForce dampingForce targetVelocity targetAngularVelocity relativeOrientationDelta relativeOrientationRotationDelta springTorque dampingTorque |
	targetPosition := firstObject transformPositionToWorld: targetRelativePosition.
	targetOrientation := firstObject transformOrientationToWorld: targetRelativeOrientation.
	
	relativePositionDelta := targetPosition - secondObject position.
	targetVelocity := firstObject linearVelocity - secondObject linearVelocity.
	springForce := relativePositionDelta * stiffness.
	dampingForce := targetVelocity * damping.
	secondObject applyForce: (springForce + dampingForce) * secondObject mass.

	targetAngularVelocity := firstObject angularVelocity - secondObject angularVelocity.
	
	relativeOrientationDelta := targetOrientation * secondObject orientation inverse.
	(targetOrientation dot: secondObject orientation) < 0 ifTrue: [
		relativeOrientationDelta := relativeOrientationDelta negated
	].
	relativeOrientationRotationDelta := relativeOrientationDelta normalized ln * 2.0.
	springTorque := relativeOrientationRotationDelta xyz * stiffness.
	dampingTorque := targetAngularVelocity * damping.
	secondObject applyTorque: (secondObject worldInertiaTensor * (springTorque + dampingTorque)).
]

{ #category : 'initialization' }
WDPHoldObjectConstraint >> initialize [
	super initialize.
	targetRelativePosition := Vector3 zeros.
	targetRelativeOrientation := Quaternion identity.
	
]

{ #category : 'accessing' }
WDPHoldObjectConstraint >> targetRelativeOrientation [

	^ targetRelativeOrientation
]

{ #category : 'accessing' }
WDPHoldObjectConstraint >> targetRelativeOrientation: anObject [

	targetRelativeOrientation := anObject
]

{ #category : 'accessing' }
WDPHoldObjectConstraint >> targetRelativePosition [

	^ targetRelativePosition
]

{ #category : 'accessing' }
WDPHoldObjectConstraint >> targetRelativePosition: anObject [

	targetRelativePosition := anObject
]
