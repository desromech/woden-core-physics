"
I am a sphere collision shape.
"
Class {
	#name : #WDPSphereCollisionShape,
	#superclass : #WDPConvexCollisionShape,
	#instVars : [
		'radius'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #accessing }
WDPSphereCollisionShape class >> radius: radius [
	^ self new radius: radius; yourself
]

{ #category : #adding }
WDPSphereCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addUVSphereWithRadius: radius segments: 16 slices: 16;
			mesh) asSceneNode 
]

{ #category : #initialization }
WDPSphereCollisionShape >> initialize [
	super initialize.
	radius := 1.0.
	
]

{ #category : #'intersection testing' }
WDPSphereCollisionShape >> localSupportInDirection: aDirection [
	^ aDirection normalized * radius
]

{ #category : #accessing }
WDPSphereCollisionShape >> radius [

	^ radius
]

{ #category : #accessing }
WDPSphereCollisionShape >> radius: aNumber [
	radius := aNumber.
	self localBoundingBox: (AABox halfExtent: radius)
]
