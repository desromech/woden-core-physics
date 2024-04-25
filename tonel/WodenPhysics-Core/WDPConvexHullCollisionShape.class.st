Class {
	#name : #WDPConvexHullCollisionShape,
	#superclass : #WDPConvexCollisionShape,
	#instVars : [
		'points'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #construction }
WDPConvexHullCollisionShape class >> withPoints: aListOfPoints [
	^ self new points: aListOfPoints; yourself
]

{ #category : #adding }
WDPConvexHullCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithBox: self localBoundingBox;
			mesh) asSceneNode
]

{ #category : #'intersection testing' }
WDPConvexHullCollisionShape >> localSupportInDirection: aDirection [
	| bestDistance bestFound |
	bestDistance := Float negativeInfinity.
	bestFound := Vector3 zeros.
	points do: [ :each |
		| distance |
		distance := each dot: aDirection.
		distance > bestFound ifTrue: [ 
			bestDistance := distance.
			bestFound := each.
		]
	].

	^ bestFound
]

{ #category : #accessing }
WDPConvexHullCollisionShape >> points [

	^ points
]

{ #category : #accessing }
WDPConvexHullCollisionShape >> points: aListOfPoints [
	points := aListOfPoints.
	self localBoundingBox: (AABox encompassing: points).
]
