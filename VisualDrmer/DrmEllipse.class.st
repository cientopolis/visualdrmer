Class {
	#name : #DrmEllipse,
	#superclass : #RSEllipse,
	#category : #VisualDrmer
}

{ #category : #geometry }
DrmEllipse >> geometry [ 
	| rect e p |
	rect := self encompassingRectangle.
	e := rect extent / 2.
	p := self position.
	e = (0@0) ifTrue: [ ^ p asGPoint ].
	^ GEllipse 
		center: p
		vertex: p + (e x@ 0)
		coVertex:p + (0@ e y) 
]
