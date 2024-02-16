"
I am a capsule collision shape which is aligned along the Z axis.
"
Class {
	#name : #WDPCapsuleZCollisionShape,
	#superclass : #WDPAbstractCapsuleCollisionShape,
	#category : #'WodenPhysics-Core-Shapes'
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
