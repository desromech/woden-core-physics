"
I hold the ray casting result for a specific collision shape.
"
Class {
	#name : #WDPShapeRayCastingResult,
	#superclass : #Object,
	#instVars : [
		'shape',
		'distance',
		'normal'
	],
	#category : #'WodenPhysics-Core-Objects'
}

{ #category : #accessing }
WDPShapeRayCastingResult >> distance [

	^ distance
]

{ #category : #accessing }
WDPShapeRayCastingResult >> distance: anObject [

	distance := anObject
]

{ #category : #accessing }
WDPShapeRayCastingResult >> normal [

	^ normal
]

{ #category : #accessing }
WDPShapeRayCastingResult >> normal: anObject [

	normal := anObject
]

{ #category : #accessing }
WDPShapeRayCastingResult >> shape [

	^ shape
]

{ #category : #accessing }
WDPShapeRayCastingResult >> shape: anObject [

	shape := anObject
]
