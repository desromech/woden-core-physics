Class {
	#name : #WDPCompoundCollisionShape,
	#superclass : #WDPCollisionShape,
	#instVars : [
		'components'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #adding }
WDPCompoundCollisionShape >> addComponent: aShapeComponent [
	components add: aShapeComponent.
	components size = 1 ifTrue: [ 
		self localBoundingBox: aShapeComponent boundingBox
	] ifFalse: [ 
		self localBoundingBox: (self localBoundingBox insertBox: aShapeComponent boundingBox )
	].

]

{ #category : #adding }
WDPCompoundCollisionShape >> addShape: aShape [
	self addShape: aShape withTransform: ReversibleAffineTransform3D identity
]

{ #category : #adding }
WDPCompoundCollisionShape >> addShape: aShape withTransform: aTransform [
	| reversibleAffineTransform |
	reversibleAffineTransform := aTransform asReversibleAffineTransform.
	
	aShape isCompoundCollisionShape ifTrue: [
		aShape components do: [ :eachComponent |
			self addComponent: (WDPCompoundCollisionShapeComponent new
				shape: eachComponent shape;
				transform: (reversibleAffineTransform transformTransform: eachComponent transform);
				yourself)
		]
	] ifFalse: [ 
		self addComponent: (WDPCompoundCollisionShapeComponent new
			shape: aShape;
			transform: reversibleAffineTransform;
			yourself).
	].

]

{ #category : #accessing }
WDPCompoundCollisionShape >> components [

	^ components
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> componentsIntersectingBox: boundingBoxToTest do: aBlock [
	components do: [ :each |
		(each boundingBox hasIntersectionWithBox: boundingBoxToTest) ifTrue: [ 
			aBlock value: each
		]
	].
]

{ #category : #adding }
WDPCompoundCollisionShape >> constructVisualizationSceneNode [
	| compoundNode |
	compoundNode := WDSceneNode new.
	components do: [ :eachComponent |
		compoundNode add: (eachComponent shape constructVisualizationSceneNode
			transform: eachComponent transform;
			yourself)
	].
	
	^ compoundNode
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ otherShape detectAndComputeCollisionContactPointsAt: otherTransform withCompoundShape: self at: transform separatingAxisHint: separatingAxisHint
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withCompoundShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	| results myReversibleTransform otherLocalBoundingBox |
	results := OrderedCollection new.
	myReversibleTransform := transform asReversibleAffineTransform.
	otherLocalBoundingBox := (otherShape localBoundingBoxWithMargin transformedWith: otherTransform) inverseTransformedWith: myReversibleTransform.
	
	self componentsIntersectingBox: otherLocalBoundingBox do: [ :eachComponent |
		| componentWorldTransform |
		componentWorldTransform := myReversibleTransform transformTransform: eachComponent transform.
		results addAll: (eachComponent shape detectAndComputeCollisionContactPointsAt: componentWorldTransform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint)
	].

	^ results
]

{ #category : #initialization }
WDPCompoundCollisionShape >> initialize [
	super initialize.
	components := OrderedCollection new.
]

{ #category : #testing }
WDPCompoundCollisionShape >> isCompoundCollisionShape [
	^ true

]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> rayCast: ray [
	^ nil
]
