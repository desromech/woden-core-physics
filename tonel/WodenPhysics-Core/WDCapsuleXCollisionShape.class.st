Class {
	#name : #WDCapsuleXCollisionShape,
	#superclass : #WDCapsuleYCollisionShape,
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #adding }
WDCapsuleXCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius + halfHeight y: radius z: radius);
			mesh) asSceneNode 
]

{ #category : #'intersection testing' }
WDCapsuleXCollisionShape >> localSupportInDirection: d [
	^ (Vector3 x: d y sign * halfHeight) + (d normalized * radius).
]
