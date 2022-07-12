Class {
	#name : #BaselineOfWodenCorePhysics,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenCorePhysics
}

{ #category : #baselines }
BaselineOfWodenCorePhysics >> baseline: spec [
    <baseline>
	spec for: #'common' do: [
		spec
			baseline: #'WodenSceneGraph' with: [ spec repository: 'github://ronsaldo/woden-core-scene-graph' ];	
			package: #'WodenPhysics-Core' with: [
				spec requires: #( #'WodenSceneGraph').
			];
			package: #'WodenPhysics-Examples' with: [
				spec requires: #( #'WodenPhysics-Core').
			];
			package: #'WodenPhysics-Tests' with: [
				spec requires: #( #'WodenPhysics-Core').
			]
	].

]
