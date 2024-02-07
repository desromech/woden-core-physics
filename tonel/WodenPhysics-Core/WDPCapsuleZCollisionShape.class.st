Class {
	#name : #WDPCapsuleZCollisionShape,
	#superclass : #WDPAbstractCapsuleCollisionShape,
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #accessing }
WDPCapsuleZCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: radius y: radius z: halfHeight + radius)).
	
]

{ #category : #adding }
WDPCapsuleZCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: radius z: halfHeight);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDPCapsuleZCollisionShape >> localSupportInDirection: d [
	^ (Vector3 z: d y sign * halfHeight) + (d normalized * radius).
]
