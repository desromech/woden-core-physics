"
I am a null collision shape.
"
Class {
	#name : #WDNullCollisionShape,
	#superclass : #WDConvexCollisionShape,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenPhysics-Core-Collisions'
}

{ #category : #'instance creation' }
WDNullCollisionShape class >> new [
	self error: 'WDNullCollisionShape is a stateless singleton'
]

{ #category : #accessing }
WDNullCollisionShape class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : #adding }
WDNullCollisionShape >> constructVisualizationSceneNode [
	^ WDSceneNode new
]

{ #category : #'as yet unclassified' }
WDNullCollisionShape >> localSupportInDirection: aDirection [
	^ Vector3 zeros
]
