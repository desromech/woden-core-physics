"
I am a constraint which is used for joining a pair of objects.
"
Class {
	#name : #WDPObjectPairUnionConstraint,
	#superclass : #WDPForceGeneratorConstraint,
	#instVars : [
		'stiffness',
		'damping',
		'firstObject',
		'secondObject'
	],
	#category : #'WodenPhysics-Core-Constraints'
}

{ #category : #accessing }
WDPObjectPairUnionConstraint >> damping [

	^ damping
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> damping: anObject [

	damping := anObject
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> firstObject [

	^ firstObject
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> firstObject: anObject [

	firstObject := anObject
]

{ #category : #initialization }
WDPObjectPairUnionConstraint >> initialize [
	super initialize.
	stiffness := 50.0.
	damping := 10.0.
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> secondObject [

	^ secondObject
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> secondObject: anObject [

	secondObject := anObject
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> stiffness [

	^ stiffness
]

{ #category : #accessing }
WDPObjectPairUnionConstraint >> stiffness: anObject [

	stiffness := anObject
]
