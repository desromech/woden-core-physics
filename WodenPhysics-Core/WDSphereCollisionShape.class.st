"
I am a sphere collision shape.
"
Class {
	#name : #WDSphereCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'radius'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #accessing }
WDSphereCollisionShape class >> radius: radius [
	^ self new radius: radius; yourself
]

{ #category : #adding }
WDSphereCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addUVSphereWithRadius: radius segments: 16 slices: 16;
			mesh) asSceneNode 
]

{ #category : #'as yet unclassified' }
WDSphereCollisionShape >> localSupportInDirection: aDirection [
	^ aDirection normalized * radius
]

{ #category : #accessing }
WDSphereCollisionShape >> radius [

	^ radius
]

{ #category : #accessing }
WDSphereCollisionShape >> radius: aNumber [
	radius := aNumber.
	self localBoundingBox: (AABox halfExtent: radius)
]
