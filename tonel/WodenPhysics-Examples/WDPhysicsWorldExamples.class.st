"
I hold a collection of different physics world examples.
"
Class {
	#name : #WDPhysicsWorldExamples,
	#superclass : #Object,
	#category : #'WodenPhysics-Examples'
}

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBox [
	"
	self exampleFallingBox
	"
	(WDDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDRigidBody new
			shape: (WDBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			position: (Vector3 y: 1.0);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxAndFloor [
	"
	self exampleFallingBoxAndFloor
	"
	(WDDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDRigidBody new
			shape: (WDBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			position: (Vector3 y: 1.0);
			yourself);
		add: (WDRigidBody new
			shape: (WDBoxCollisionShape halfExtent: (Vector3 x: 2 y: 0.1 z: 2));
			mass: 0.0;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxAndFloor2 [
	"
	self exampleFallingBoxAndFloor2
	"
	(WDDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDRigidBody new
			shape: (WDBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			position: (Vector3 x: -5 y: 1 z: -20);
			yourself);
		add: (WDRigidBody new
			shape: (WDBoxCollisionShape halfExtent: (Vector3 x: 5 y: 0.1 z: 20));
			mass: 0.0;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #'see class side' }
WDPhysicsWorldExamples >> seeClassSide [
]
