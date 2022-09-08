Class {
	#name : #WDCapsuleYCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'height',
		'radius',
		'halfHeight'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #construction }
WDCapsuleYCollisionShape class >> height: height radius: radius [
	^ self new height: height; radius: radius; yourself
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> computeLocalBoundingBox [
	self localBoundingBox: (AABox halfExtent: (Vector3 x: radius y: halfHeight + radius z: radius)).
	
]

{ #category : #adding }
WDCapsuleYCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: (Vector3 x: radius y: halfHeight + radius z: radius);
			mesh) asSceneNode 
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> halfHeight [
	^ halfHeight
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> height [

	^ height
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> height: aNumber [
	height := aNumber.
	halfHeight := aNumber / 2.
	self computeLocalBoundingBox.
]

{ #category : #initialization }
WDCapsuleYCollisionShape >> initialize [
	super initialize.
	radius := 1.0.
	self height: 1.0.
]

{ #category : #'intersection testing' }
WDCapsuleYCollisionShape >> localSupportInDirection: d [
	^ (Vector3 y: d y sign * halfHeight) + (d normalized * radius).
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> radius [

	^ radius
]

{ #category : #accessing }
WDCapsuleYCollisionShape >> radius: anObject [
	radius := anObject.
	self computeLocalBoundingBox.
]
