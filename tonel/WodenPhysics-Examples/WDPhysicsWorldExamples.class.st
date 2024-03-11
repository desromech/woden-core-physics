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
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 y: 1.0);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxAndFloor [
	"
	self exampleFallingBoxAndFloor
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 y: 1.0);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 2 y: 0.1 z: 2));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxAndFloor2 [
	"
	self exampleFallingBoxAndFloor2
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 x: -5 y: 1 z: -20);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 5 y: 0.1 z: 20));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxOnBox [
	"
	self exampleFallingBoxOnBox
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 x: 0.6 y: 1.5);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -0.5);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 4 y: 0.1 z: 4));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -1.1);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingBoxOnBox2 [
	"
	self exampleFallingBoxOnBox
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 x: 0.6 y: 1.5);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 y: -0.5);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 4 y: 0.1 z: 4));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -1.1);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingCapsuleAndFloor [
	"
	self exampleFallingBoxAndFloor
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPCapsuleYCollisionShape height: 0.5 radius: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 y: 1.0);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 2 y: 0.1 z: 2));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleFallingCapsuleAndFloor2 [
	"
	self exampleFallingBoxAndFloor2
	"
	(WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		add: (WDPRigidBody new
			shape: (WDPCapsuleYCollisionShape height: 0.5 radius: 0.5);
			mass: 1.0;
			computeMassDistribution;
			position: (Vector3 x: -5 y: 1 z: -20);
			yourself);
		add: (WDPRigidBody new
			shape: (WDPBoxCollisionShape halfExtent: (Vector3 x: 5 y: 0.1 z: 20));
			mass: 0.0;
			computeMassDistribution;
			position: (Vector3 y: -0.8);
			yourself);
		buildInteractiveVisualizationScene) openInWindow
]

{ #category : #examples }
WDPhysicsWorldExamples class >> exampleRoom [
	"
	self exampleRoom
	"
	| world |
	world := WDPDiscreteDynamicPhysicsWorld new
		gravity: (Vector3 y: -9.8);
		yourself.
		
	{
		AABox min: (Vector3 x: -10 y: -0.5 z: -10) max: (Vector3 x: 10 y: 0.0 z: 10).
		AABox min: (Vector3 x: -10 y: 5.0 z: -10) max: (Vector3 x: 10 y: 5.0 z: 10).

		AABox min: (Vector3 x: -10 y: 0 z: 10) max: (Vector3 x: 10 y: 5.0 z: 10).
		AABox min: (Vector3 x: -10 y: 0 z: -10) max: (Vector3 x: 10 y: 5.0 z: -10).

		AABox min: (Vector3 x: -10 y: 0 z: -10) max: (Vector3 x: -10 y: 5.0 z: 10).
		AABox min: (Vector3 x: 10 y: 0 z: -10) max: (Vector3 x: 10 y: 5.0 z: 10).

		AABox min: (Vector3 x: -1 y: 0 z: -6) max: (Vector3 x: 1 y: 1.0 z: -5).
	} do: [ :eachBox |
		world add: (WDPCollisionObject new
			shape: (WDPBoxCollisionShape halfExtent: eachBox halfExtent);
			position: eachBox center;
			yourself)
	].

	world add: (WDPRigidBody new
		shape: (WDPBoxCollisionShape halfExtent: 0.125);
		mass: 1.0;
		computeMassDistribution;
		position: (Vector3 x: 0.0 y: 1.5 z: -3);
		yourself).

	world add: (WDPRigidBody new
		shape: (WDPCapsuleYCollisionShape height: 1.6 - 0.6 radius: 0.3);
		mass: 70.0;
		computeMassDistribution;
		position: (Vector3 x: 0.0 y: 2.0 z: 0);
		yourself).

	world buildInteractiveVisualizationScene openInWindow
]

{ #category : #'see class side' }
WDPhysicsWorldExamples >> seeClassSide [
]
