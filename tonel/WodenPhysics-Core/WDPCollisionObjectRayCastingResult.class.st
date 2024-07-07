"
I encapsulate a specific ray casting query result.
"
Class {
	#name : 'WDPCollisionObjectRayCastingResult',
	#superclass : 'WDShapeRayCastingResult',
	#instVars : [
		'collisionObject'
	],
	#category : 'WodenPhysics-Core-Objects',
	#package : 'WodenPhysics-Core',
	#tag : 'Objects'
}

{ #category : 'accessing' }
WDPCollisionObjectRayCastingResult >> collisionObject [

	^ collisionObject
]

{ #category : 'accessing' }
WDPCollisionObjectRayCastingResult >> collisionObject: anObject [

	collisionObject := anObject
]
