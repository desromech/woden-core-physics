"
I am a generator of forces.
"
Class {
	#name : #WDPForceGenerator,
	#superclass : #Object,
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #adding }
WDPForceGenerator >> addOntoPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld addForceGenerator: self
]

{ #category : #evaluation }
WDPForceGenerator >> evaluateWithDeltaTime: deltaTime [
]
