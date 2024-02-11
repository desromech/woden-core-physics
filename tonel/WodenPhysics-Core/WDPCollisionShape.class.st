"
I represent a specific collision shape.
"
Class {
	#name : #WDPCollisionShape,
	#superclass : #Object,
	#instVars : [
		'margin',
		'localBoundingBox',
		'localBoundingBoxWithMargin'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #testing }
WDPCollisionShape class >> isAbstract [
	^ self == WDPCollisionShape
]

{ #category : #adding }
WDPCollisionShape >> constructVisualizationSceneNode [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDPCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform with: otherShape at: otherTransform [
	self subclassResponsibility
]

{ #category : #accessing }
WDPCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform withConvexShape: otherShape at: otherTransform [
	self subclassResponsibility
]

{ #category : #initialization }
WDPCollisionShape >> initialize [
	super initialize.
	margin := 0.01.
	localBoundingBox := AABox new.
	localBoundingBoxWithMargin := nil.
]

{ #category : #accessing }
WDPCollisionShape >> localBoundingBox [

	^ localBoundingBox
]

{ #category : #accessing }
WDPCollisionShape >> localBoundingBox: anAABox [
	localBoundingBox := anAABox.
	localBoundingBoxWithMargin := nil.
]

{ #category : #accessing }
WDPCollisionShape >> localBoundingBoxWithMargin [
	^ localBoundingBoxWithMargin ifNil: [ localBoundingBoxWithMargin := self localBoundingBox withExpandedHalfExtent: margin ]
]

{ #category : #accessing }
WDPCollisionShape >> margin [

	^ margin
]

{ #category : #accessing }
WDPCollisionShape >> margin: aNumber [
	margin := aNumber.
	localBoundingBoxWithMargin := nil.
]
