"
I am a generator of forces.
"
Class {
	#name : 'WDPForceGenerator',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'WodenPhysics-Core-Constraints',
	#package : 'WodenPhysics-Core',
	#tag : 'Constraints'
}

{ #category : 'adding' }
WDPForceGenerator >> addOntoPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld addForceGenerator: self
]

{ #category : 'evaluation' }
WDPForceGenerator >> evaluateWithDeltaTime: deltaTime [
]

{ #category : 'accessing' }
WDPForceGenerator >> owner [

	^ owner
]

{ #category : 'accessing' }
WDPForceGenerator >> owner: anObject [

	owner := anObject
]

{ #category : 'adding' }
WDPForceGenerator >> removeFromPhysicsWorld: aPhysicsWorld [
	aPhysicsWorld removeForceGenerator: self
]
