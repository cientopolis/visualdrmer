Extension { #name : #DrmSource }

{ #category : #'*VisualDrmer' }
DrmSource >> citationBody [
	^ notes
]

{ #category : #'*VisualDrmer' }
DrmSource >> citationLabel [
	^ '[' , self label , '] '
]
