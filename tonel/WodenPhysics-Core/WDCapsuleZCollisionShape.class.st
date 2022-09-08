Class {
	#name : #WDCapsuleZCollisionShape,
	#superclass : #WDCapsuleYCollisionShape,
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #adding }
WDCapsuleZCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: radius z: halfHeight);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDCapsuleZCollisionShape >> localSupportInDirection: d [
	^ (Vector3 z: d y sign * halfHeight) + (d normalized * radius).
]
