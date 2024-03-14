"
I am a constraint which is used for joining a pair of objects.
"
Class {
	#name : #WDPPairObjectUnionConstraint,
	#superclass : #WDPForceGeneratorConstraint,
	#instVars : [
		'stiffness',
		'firstObject',
		'secondObject'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObject [

	^ firstObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> firstObject: anObject [

	firstObject := anObject
]

{ #category : #initialization }
WDPPairObjectUnionConstraint >> initialize [
	super initialize.
	stiffness := 50.0.
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObject [

	^ secondObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> secondObject: anObject [

	secondObject := anObject
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> stiffness [

	^ stiffness
]

{ #category : #accessing }
WDPPairObjectUnionConstraint >> stiffness: anObject [

	stiffness := anObject
]
