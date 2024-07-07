"
I hold a set of collision bit masks.
"
Class {
	#name : 'WDPCollisionMasks',
	#superclass : 'Object',
	#classVars : [
		'AllNonSolid',
		'AllSolid',
		'CharacterObject',
		'DefaultCollisionGroup',
		'DefaultCollisionResponseGroup',
		'Kinematic',
		'RigidBody',
		'Sensor',
		'Static',
		'Vehicle'
	],
	#category : 'WodenPhysics-Core-CollisionObjects',
	#package : 'WodenPhysics-Core',
	#tag : 'CollisionObjects'
}

{ #category : 'accessing' }
WDPCollisionMasks class >> allNonSolid [
	^ AllNonSolid
]

{ #category : 'accessing' }
WDPCollisionMasks class >> allSolid [
	^ AllSolid
]

{ #category : 'accessing' }
WDPCollisionMasks class >> character [
	^ CharacterObject
]

{ #category : 'accessing' }
WDPCollisionMasks class >> defaultCollisionGroup [
	^ DefaultCollisionGroup
]

{ #category : 'accessing' }
WDPCollisionMasks class >> defaultCollisionResponseGroup [
	^ DefaultCollisionResponseGroup
]

{ #category : 'class initialization' }
WDPCollisionMasks class >> initialize [
	Static := 1<<0.
	Kinematic := 1<<1.
	RigidBody := 1<<2.
	CharacterObject := 1<<3.
	Vehicle := 1<<4.
	Sensor := 1<<5.
	
	AllSolid := Static | Kinematic | RigidBody | Vehicle | CharacterObject.
	AllNonSolid := Sensor.
	
	DefaultCollisionGroup := RigidBody.
	DefaultCollisionResponseGroup := AllSolid.
]

{ #category : 'accessing' }
WDPCollisionMasks class >> kinematic [
	^ Kinematic
]

{ #category : 'accessing' }
WDPCollisionMasks class >> rigidBody [
	^ RigidBody
]

{ #category : 'accessing' }
WDPCollisionMasks class >> sensor [
	^ Sensor
]

{ #category : 'accessing' }
WDPCollisionMasks class >> static [
	^ Static
]

{ #category : 'accessing' }
WDPCollisionMasks class >> vehicle [
	^ Vehicle
]
