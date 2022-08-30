"
I represent a convex collision shape.
"
Class {
	#name : #WDConvexCollisionShape,
	#superclass : #WDCollisionShape,
	#classVars : [
		'ShallowPenetrationThreshold'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #initialization }
WDConvexCollisionShape class >> initialize [
	ShallowPenetrationThreshold := 1e-5.
]

{ #category : #testing }
WDConvexCollisionShape class >> isAbstract [
	^ self == WDConvexCollisionShape
]

{ #category : #accessing }
WDConvexCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform with: otherShape at: otherTransform [
	^ otherShape detectAndComputeCollisionContactManifoldAt: otherTransform withConvexShape: self at: transform
]

{ #category : #accessing }
WDConvexCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform withConvexShape: otherShape at: otherTransform [
	| firstSupportFunction secondSupportFunction
		gjkSimplex closestPointToOrigin totalMargin shapeDistance |
	firstSupportFunction := GeometricFunctions transformSupportFunction: self localSupportFunction with: transform.
	secondSupportFunction := GeometricFunctions transformSupportFunction: otherShape localSupportFunction with: otherTransform.
	gjkSimplex := GeometricFunctions gjkSimplexFor: firstSupportFunction with: secondSupportFunction.
	
	closestPointToOrigin := gjkSimplex closestPointToOrigin.
	totalMargin := margin + otherShape margin.
	shapeDistance := closestPointToOrigin length.
	shapeDistance > totalMargin ifTrue: [ ^ nil ].

	shapeDistance >= ShallowPenetrationThreshold ifTrue: [
		^ WDContactManifold new
			normal: closestPointToOrigin normalized negated;
			penetrationDistance: totalMargin - shapeDistance;
			yourself
	] ifFalse: [
		| distanceAndNormal |
		Transcript show: 'Deep penetration'; cr.
		distanceAndNormal := GeometricFunctions samplePenetrationDistanceAndNormalForSupport: firstSupportFunction with: secondSupportFunction.
		distanceAndNormal ifNil: [ ^ nil ].
		
		^ WDContactManifold new
			normal: distanceAndNormal second;
			penetrationDistance: distanceAndNormal first + totalMargin;
			yourself
	]
]

{ #category : #'intersection testing' }
WDConvexCollisionShape >> localSupportFunction [
	^ [ :d | self localSupportInDirection: d ]
]

{ #category : #'as yet unclassified' }
WDConvexCollisionShape >> localSupportInDirection: aDirection [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDConvexCollisionShape >> localSupportInDirectionWithMargin: aDirection [
	^ (self localSupportInDirection: aDirection) + margin
]
