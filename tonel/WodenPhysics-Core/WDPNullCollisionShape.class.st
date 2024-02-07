"
I am a null collision shape.
"
Class {
	#name : #WDPNullCollisionShape,
	#superclass : #WDPConvexCollisionShape,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #'instance creation' }
WDPNullCollisionShape class >> new [
	self error: 'WDNullCollisionShape is a stateless singleton'
]

{ #category : #accessing }
WDPNullCollisionShape class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : #adding }
WDPNullCollisionShape >> constructVisualizationSceneNode [
	^ WDSceneNode new
]

{ #category : #'intersection testing' }
WDPNullCollisionShape >> localSupportInDirection: aDirection [
	^ Vector3 zeros
]
