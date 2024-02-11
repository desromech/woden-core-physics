Class {
	#name : #WDPCapsuleYCollisionShape,
	#superclass : #WDPAbstractCapsuleCollisionShape,
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #construction }
WDPCapsuleYCollisionShape class >> height: height radius: radius [
	^ self new height: height; radius: radius; yourself
]

{ #category : #accessing }
WDPCapsuleYCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: radius y: halfHeight + radius z: radius)).
	
]

{ #category : #adding }
WDPCapsuleYCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: halfHeight + radius z: radius);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDPCapsuleYCollisionShape >> localSupportInDirection: d [
	^ (Vector3 y: d y sign * halfHeight) + (d normalized * radius).
]
