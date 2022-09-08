"
I am an axis-aligned (in local space) box collision shape.
"
Class {
	#name : #WDBoxCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#instVars : [
		'halfExtent'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #accessing }
WDBoxCollisionShape class >> halfExtent: halfExtent [
	^ self new halfExtent: halfExtent; yourself
]

{ #category : #adding }
WDBoxCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: halfExtent;
			mesh) asSceneNode 
]

{ #category : #accessing }
WDBoxCollisionShape >> halfExtent [

	^ halfExtent
]

{ #category : #accessing }
WDBoxCollisionShape >> halfExtent: newHalfExtent [
	halfExtent := newHalfExtent asVector3.
	self localBoundingBox: (AABox halfExtent: halfExtent).
]

{ #category : #initialization }
WDBoxCollisionShape >> initialize [
	super initialize.
	halfExtent := Vector3 ones
]

{ #category : #'intersection testing' }
WDBoxCollisionShape >> localSupportInDirection: aDirection [
	^ halfExtent * aDirection nonZeroSign
]
