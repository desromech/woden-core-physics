"
I encapsulate a specific ray casting query result.
"
Class {
	#name : #WDPCollisionObjectRayCastingResult,
	#superclass : #WDPShapeRayCastingResult,
	#instVars : [
		'collisionObject'
	],
	#category : #'WodenPhysics-Core-Objects'
}

{ #category : #accessing }
WDPCollisionObjectRayCastingResult >> collisionObject [

	^ collisionObject
]

{ #category : #accessing }
WDPCollisionObjectRayCastingResult >> collisionObject: anObject [

	collisionObject := anObject
]
