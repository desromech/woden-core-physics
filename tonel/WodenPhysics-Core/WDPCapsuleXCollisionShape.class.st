Class {
	#name : #WDPCapsuleXCollisionShape,
	#superclass : #WDPAbstractCapsuleCollisionShape,
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #accessing }
WDPCapsuleXCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: halfHeight + radius y: radius z: radius)).
	
]

{ #category : #adding }
WDPCapsuleXCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius + halfHeight y: radius z: radius);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDPCapsuleXCollisionShape >> localSupportInDirection: d [
	^ (Vector3 x: d y sign * halfHeight) + (d normalized * radius).
]
