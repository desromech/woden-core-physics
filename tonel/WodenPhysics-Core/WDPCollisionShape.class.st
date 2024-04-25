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

{ #category : #'mass distribution' }
WDPCollisionShape >> computeInertiaTensorWithMass: mass [
	^ Matrix3x3 zeros
]

{ #category : #adding }
WDPCollisionShape >> constructVisualizationSceneNode [
	^ self subclassResponsibility
]

{ #category : #'collision detection' }
WDPCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : #'collision detection' }
WDPCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : #'collision detection' }
WDPCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	self subclassResponsibility
]

{ #category : #initialization }
WDPCollisionShape >> initialize [
	super initialize.
	margin := 0.01.
	localBoundingBox := AABox new.
	localBoundingBoxWithMargin := nil.
]

{ #category : #testing }
WDPCollisionShape >> isCompoundCollisionShape [
	^ false
]

{ #category : #testing }
WDPCollisionShape >> isEmptyShape [
	^ false
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

{ #category : #testing }
WDPCollisionShape >> rayCast: ray [
	self subclassResponsibility
]

{ #category : #testing }
WDPCollisionShape >> withTransform: shapeTransform intersectsBox: box withTransform: boxTransform [
	^ false
]

{ #category : #testing }
WDPCollisionShape >> withTransform: shapeTransform intersectsSphere: sphere [
	^ self withTransform: shapeTransform intersectsSphere: sphere withTransform: ReversibleAffineTransform3D identity
]

{ #category : #testing }
WDPCollisionShape >> withTransform: shapeTransform intersectsSphere: sphere withTransform: sphereTransform [
	^ false
]
