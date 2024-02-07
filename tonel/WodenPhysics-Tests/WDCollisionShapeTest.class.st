"
A WDCollisionShapeTest is a test class for testing the behavior of WDCollisionShape
"
Class {
	#name : #WDCollisionShapeTest,
	#superclass : #TestCase,
	#category : #'WodenPhysics-Tests'
}

{ #category : #tests }
WDCollisionShapeTest >> testBox [
	| box |
	box := WDPBoxCollisionShape halfExtent: (Vector3 x: 1 y: 2 z: 3).
	self assert: box halfExtent equals: (Vector3 x: 1 y: 2 z: 3).
	self assert: box localBoundingBox min x equals: -1.
	self assert: box localBoundingBox min y equals: -2.
	self assert: box localBoundingBox min z equals: -3.
	self assert: box localBoundingBox max x equals: 1.
	self assert: box localBoundingBox max y equals: 2.
	self assert: box localBoundingBox max z equals: 3.
]

{ #category : #tests }
WDCollisionShapeTest >> testSphere [
	| sphere |
	sphere := WDPSphereCollisionShape radius: 1.
	self assert: sphere radius equals: 1.
	self assert: sphere localBoundingBox min x equals: -1.
	self assert: sphere localBoundingBox min y equals: -1.
	self assert: sphere localBoundingBox min z equals: -1.
	self assert: sphere localBoundingBox max x equals: 1.
	self assert: sphere localBoundingBox max y equals: 1.
	self assert: sphere localBoundingBox max z equals: 1.

]
