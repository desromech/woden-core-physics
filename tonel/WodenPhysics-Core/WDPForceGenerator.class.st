"
I am a generator of forces.
"
Class {
	#name : #WDPForceGenerator,
	#superclass : #Object,
	#instVars : [
		'owner'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #adding }
WDPForceGenerator >> addOntoPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld addForceGenerator: self
]

{ #category : #evaluation }
WDPForceGenerator >> evaluateWithDeltaTime: deltaTime [
]

{ #category : #accessing }
WDPForceGenerator >> owner [

	^ owner
]

{ #category : #accessing }
WDPForceGenerator >> owner: anObject [

	owner := anObject
]
