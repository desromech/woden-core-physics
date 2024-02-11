"
I represent a convex collision shape.
"
Class {
	#name : #WDPConvexCollisionShape,
	#superclass : #WDPCollisionShape,
	#classVars : [
		'ShallowPenetrationThreshold'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #initialization }
WDPConvexCollisionShape class >> initialize [
	ShallowPenetrationThreshold := 1e-5.
]

{ #category : #testing }
WDPConvexCollisionShape class >> isAbstract [
	^ self == WDPConvexCollisionShape
]

{ #category : #accessing }
WDPConvexCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform with: otherShape at: otherTransform [
	^ otherShape detectAndComputeCollisionContactManifoldAt: otherTransform withConvexShape: self at: transform
]

{ #category : #accessing }
WDPConvexCollisionShape >> detectAndComputeCollisionContactManifoldAt: transform withConvexShape: otherShape at: otherTransform [
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
		^ WDPContactManifold new
			normal: closestPointToOrigin normalized;
			penetrationDistance: totalMargin - shapeDistance;
			firstPoint: gjkSimplex closestPointToOriginInFirst;
			secondPoint: gjkSimplex closestPointToOriginInSecond;
			yourself
	] ifFalse: [
		| distanceAndNormal |
		Transcript show: 'Deep penetration'; cr.
		distanceAndNormal := GeometricFunctions samplePenetrationDistanceAndNormalForSupport: firstSupportFunction with: secondSupportFunction.
		distanceAndNormal ifNil: [ ^ nil ].
		
		^ WDPContactManifold new
			normal: distanceAndNormal second;
			penetrationDistance: distanceAndNormal first + totalMargin;
			firstPoint: distanceAndNormal third;
			secondPoint: distanceAndNormal fourth;
			yourself
	]
]

{ #category : #'intersection testing' }
WDPConvexCollisionShape >> localSupportFunction [
	^ [ :d | self localSupportInDirection: d ]
]

{ #category : #'intersection testing' }
WDPConvexCollisionShape >> localSupportInDirection: aDirection [
	self subclassResponsibility
]

{ #category : #'intersection testing' }
WDPConvexCollisionShape >> localSupportInDirectionWithMargin: aDirection [
	^ (self localSupportInDirection: aDirection) + margin
]
