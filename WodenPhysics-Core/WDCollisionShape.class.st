"
I represent a specific collision shape.
"
Class {
	#name : #WDCollisionShape,
	#superclass : #Object,
	#instVars : [
		'margin',
		'localBoundingBox',
		'localBoundingBoxWithMargin'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #testing }
WDCollisionShape class >> isAbstract [
	^ self == WDCollisionShape
]

{ #category : #adding }
WDCollisionShape >> constructVisualizationSceneNode [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform with: otherShape at: otherTransform [
	self subclassResponsibility
]

{ #category : #accessing }
WDCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform withConvexShape: otherShape at: otherTransform [
	self subclassResponsibility
]

{ #category : #initialization }
WDCollisionShape >> initialize [
	super initialize.
	margin := 0.01.
	localBoundingBox := AABox new.
	localBoundingBoxWithMargin := nil.
]

{ #category : #accessing }
WDCollisionShape >> localBoundingBox [

	^ localBoundingBox
]

{ #category : #accessing }
WDCollisionShape >> localBoundingBox: anAABox [
	localBoundingBox := anAABox.
	localBoundingBoxWithMargin := nil.
]

{ #category : #accessing }
WDCollisionShape >> localBoundingBoxWithMargin [
	^ localBoundingBoxWithMargin ifNil: [ localBoundingBoxWithMargin := self localBoundingBox withExpandedHalfExtent: margin ]
]

{ #category : #accessing }
WDCollisionShape >> margin [

	^ margin
]

{ #category : #accessing }
WDCollisionShape >> margin: aNumber [
	margin := aNumber.
	localBoundingBoxWithMargin := nil.
]
