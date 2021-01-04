Extension { #name : #DrmLink }

{ #category : #'*VisualDrmer' }
DrmLink >> destinationAsString [
	^String streamContents: [:s | self printLevel: levelAtDestination on: s]
]

{ #category : #'*VisualDrmer' }
DrmLink >> originAsString [
	^String streamContents: [:s | self printLevel: levelAtOrigin  on: s]
]

{ #category : #'*VisualDrmer' }
DrmLink >> sourcesAsString [
	^ String
		streamContents: [ :s | self sources do: [ :each | each printOn: s ] ]
]
