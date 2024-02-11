Class {
	#name : #WDPAbstractCapsuleCollisionShape,
	#superclass : #WDPConvexCollisionShape,
	#instVars : [
		'height',
		'radius',
		'halfHeight'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #construction }
WDPAbstractCapsuleCollisionShape class >> height: height radius: radius [
	^ self new height: height; radius: radius; yourself
]

{ #category : #testing }
WDPAbstractCapsuleCollisionShape class >> isAbstract [
	^ self == WDPAbstractCapsuleCollisionShape
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> computeLocalBoundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> halfHeight [
	^ halfHeight
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> height [

	^ height
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> height: aNumber [
	height := aNumber.
	halfHeight := aNumber / 2.
	self computeLocalBoundingBox.
]

{ #category : #initialization }
WDPAbstractCapsuleCollisionShape >> initialize [
	super initialize.
	radius := 1.0.
	self height: 1.0.
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> radius [

	^ radius
]

{ #category : #accessing }
WDPAbstractCapsuleCollisionShape >> radius: anObject [
	radius := anObject.
	self computeLocalBoundingBox.
]
