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
WDPConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform with: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	^ (otherShape detectAndComputeCollisionContactPointsAt: otherTransform withConvexShape: self at: transform separatingAxisHint: (separatingAxisHint ifNotNil: [separatingAxisHint negated])) collect: [ :each | each flipped ]
]

{ #category : #accessing }
WDPConvexCollisionShape >> detectAndComputeCollisionContactPointsAt: transform withConvexShape: otherShape at: otherTransform separatingAxisHint: separatingAxisHint [
	| firstSupportFunction secondSupportFunction
		gjkSimplex closestPointToOrigin totalMargin shapeDistance |
	firstSupportFunction := GeometricFunctions transformSupportFunction: self localSupportFunction with: transform.
	secondSupportFunction := GeometricFunctions transformSupportFunction: otherShape localSupportFunction with: otherTransform.
	gjkSimplex := GeometricFunctions gjkSimplexFor: firstSupportFunction with: secondSupportFunction separatingAxisHint: separatingAxisHint.
	
	closestPointToOrigin := gjkSimplex closestPointToOrigin.
	totalMargin := margin + otherShape margin.
	shapeDistance := closestPointToOrigin length.

	shapeDistance > totalMargin ifTrue: [ ^ #() ].	

	shapeDistance >= ShallowPenetrationThreshold ifTrue: [
		^ {WDPContactPoint new
				normal: closestPointToOrigin normalized;
				requiredSeparation: totalMargin;
				firstPoint: gjkSimplex closestPointToOriginInFirst;
				secondPoint: gjkSimplex closestPointToOriginInSecond;
				computeLocalVersionWithFirstTransform: transform secondTransform: otherTransform;
				computeWorldContactPointAndDistances;
				yourself
		}
	] ifFalse: [
		| distanceAndNormal |
		distanceAndNormal := GeometricFunctions samplePenetrationContactForSupport: firstSupportFunction with: secondSupportFunction margin: totalMargin separatingAxisHint: separatingAxisHint.
		distanceAndNormal ifNil: [ ^ #() ].
		
		^ {WDPContactPoint new
				normal: distanceAndNormal second;
				requiredSeparation: totalMargin;
				firstPoint: distanceAndNormal third;
				secondPoint: distanceAndNormal fourth;
				computeLocalVersionWithFirstTransform: transform secondTransform: otherTransform;
				computeWorldContactPointAndDistances;
				yourself
		}
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

{ #category : #accessing }
WDPConvexCollisionShape >> rayCast: ray [
	| gjkResult |
	gjkResult := GeometricFunctions gjkRayCast: ray support: [:d | self localSupportInDirectionWithMargin: d].
	gjkResult ifNil: [ ^ nil ].
	
	^ WDPShapeRayCastingResult new
		shape: self;
		distance: gjkResult first;
		normal: gjkResult second normalized;
		yourself
	
	
]
