Class {
	#name : #WDPCompoundCollisionShapeComponent,
	#superclass : #Object,
	#instVars : [
		'shape',
		'transform'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #accessing }
WDPCompoundCollisionShapeComponent >> shape [

	^ shape
]

{ #category : #accessing }
WDPCompoundCollisionShapeComponent >> shape: anObject [

	shape := anObject
]

{ #category : #accessing }
WDPCompoundCollisionShapeComponent >> transform [

	^ transform
]

{ #category : #accessing }
WDPCompoundCollisionShapeComponent >> transform: anObject [

	transform := anObject
]
