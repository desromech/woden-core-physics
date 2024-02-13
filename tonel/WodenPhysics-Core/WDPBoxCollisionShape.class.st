"
I am an axis-aligned (in local space) box collision shape.
"
Class {
	#name : #WDPBoxCollisionShape,
	#superclass : #WDPConvexCollisionShape,
	#instVars : [
		'halfExtent'
	],
	#category : #'WodenPhysics-Core-Shapes'
}

{ #category : #accessing }
WDPBoxCollisionShape class >> halfExtent: halfExtent [
	^ self new halfExtent: halfExtent; yourself
]

{ #category : #'mass distribution' }
WDPBoxCollisionShape >> computeInertiaTensorWithMass: mass [
	| extent extentSquared mo12 |
	extent := halfExtent * 2.
	extentSquared := extent * extent.
	mo12 := mass / 12.
	
	^ Matrix3x3 new
		m11: (extentSquared y + extentSquared z) * mo12;
		m22: (extentSquared x + extentSquared z) * mo12;
		m33: (extentSquared x + extentSquared y) * mo12;
		yourself
]

{ #category : #adding }
WDPBoxCollisionShape >> constructVisualizationSceneNode [
	^ (WDMeshBuilder new
			addCubeWithHalfExtent: halfExtent;
			mesh) asSceneNode 
]

{ #category : #accessing }
WDPBoxCollisionShape >> halfExtent [

	^ halfExtent
]

{ #category : #accessing }
WDPBoxCollisionShape >> halfExtent: newHalfExtent [
	halfExtent := newHalfExtent asVector3.
	self localBoundingBox: (AABox halfExtent: halfExtent).
]

{ #category : #initialization }
WDPBoxCollisionShape >> initialize [
	super initialize.
	halfExtent := Vector3 ones
]

{ #category : #'intersection testing' }
WDPBoxCollisionShape >> localSupportInDirection: aDirection [
	^ halfExtent * aDirection nonZeroSign
]
