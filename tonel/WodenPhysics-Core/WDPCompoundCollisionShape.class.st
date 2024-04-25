Class {
	#name : #WDPCompoundCollisionShape,
	#superclass : #WDPCollisionShape,
	#instVars : [
		'components'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #adding }
WDPCompoundCollisionShape >> addShape: aShape withTransform: aTransform [
	components add: (WDPCompoundCollisionShapeComponent new
		shape: aShape;
		transform: aTransform;
		yourself).
]

{ #category : #accessing }
WDPCompoundCollisionShape >> components [

	^ components
]

{ #category : #adding }
WDPCompoundCollisionShape >> constructVisualizationSceneNode [
	| compoundNode |
	compoundNode := WDSceneNode new.
	components do: [ :eachComponent |
		compoundNode add: (eachComponent constructVisualizationSceneNode
			transform: eachComponent transform;
			yourself)
	].
	
	^ compoundNode
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ #()
]

{ #category : #initialization }
WDPCompoundCollisionShape >> initialize [
	super initialize.
	components := OrderedCollection new.
]

{ #category : #'collision detection' }
WDPCompoundCollisionShape >> rayCast: ray [
	^ nil
]
