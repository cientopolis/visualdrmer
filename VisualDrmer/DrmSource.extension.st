Extension { #name : #DrmSource }

{ #category : #'*VisualDrmer' }
DrmSource >> citationBody [
	^ '[' , self label , '] ', notes
]

{ #category : #'*VisualDrmer' }
DrmSource >> citationLabel [
	^ '[' , self label , '] '
]
