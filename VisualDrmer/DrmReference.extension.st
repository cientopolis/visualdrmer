Extension { #name : #DrmReference }

{ #category : #'*VisualDrmer' }
DrmReference >> citationBody [
	^ '[' , self label , '] ' , citation
]
