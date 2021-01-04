Class {
	#name : #BaselineOfVisualDrmer,
	#superclass : #BaselineOf,
	#category : #BaselineOfVisualDrmer
}

{ #category : #baselines }
BaselineOfVisualDrmer >> baseline: spec [
	<baseline>
	self
		drmer: spec;
		roassal3: spec.
	spec
		package: 'VisualDrmer'
		with: [ spec requires: #('Roassal3' 'Drmer').
			spec postLoadDoIt: #postLoadActions ]
]

{ #category : #baselines }
BaselineOfVisualDrmer >> drmer: spec [
	spec
		baseline: 'Drmer'
		with: [ spec repository: 'github://cientopolis/drmer:main' ].
]

{ #category : #baselines }
BaselineOfVisualDrmer >> roassal3: spec [
	spec
		baseline: 'Roassal3'
		with: [ spec repository: 'github://ObjectProfile/Roassal3:v0.9.5' ].
]
