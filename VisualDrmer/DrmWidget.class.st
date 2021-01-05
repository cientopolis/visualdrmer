Class {
	#name : #DrmWidget,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'model'
	],
	#category : #'VisualDrmer-RoassalWidget'
}

{ #category : #running }
DrmWidget >> applyLayout:shapes edges:edges [
	|layout|
	layout := RSForceBasedLayout new.
	layout nodes: shapes.
	layout edges: edges.
	layout start.
	shapes
		do: [ :node | 
			(layout mockElementAt: node)
				charge: node width * -10;
				weight: node width ].
	edges
		do: [ :edge | 
			(layout mockEdgeAt: edge)
				strength: 1;
				length: edge from width + edge to width ].
	layout runLayoutSimply.
]

{ #category : #accessing }
DrmWidget >> canvas [
	^ canvas
]

{ #category : #running }
DrmWidget >> createEdges [
	|marker|
	marker:= RSShapeFactory arrow.
	marker size: 10. 
	RSEdgeBuilder line
		attachPoint: (RSBorderAttachPoint new 
			endOffset:5;yourself); 
		canvas:canvas;
		markerEnd:marker;
		source: self model links
			connectFrom: [ :link | link origin ]
			to: [ :link | link destination ].
	canvas edges with: self model links do:[:line :link | 
		line model:link.
		self createLineLabelFor: line ].
	
	^canvas edges. 
]

{ #category : #running }
DrmWidget >> createFactorBackground: unFactor [
	|border|
	border:= unFactor isExternal 
		ifTrue: [ RSBorder new dashArray: #(4) ] 
		ifFalse: [RSBorder new ].
	^ DrmEllipse new
		border: (border);
		yourself
]

{ #category : #running }
DrmWidget >> createLineLabelFor:line [
	|link percents|
	link:= line model.
	percents:=#(0.2 0.5 0.8). 
	{link originAsString.
	 link sourcesAsString. 
	 link destinationAsString.} doWithIndex: [ :string :index | 
		|label percent|
		label:= RSLabel new 
			text: string;
			yourself.
		percent:= percents at:index. 
		canvas add:label. 
		line when:RSExtentChangedEvent do:[:evt |
			|a b newPosition vector|
			a:= line startPoint.
			b:= line endPoint.
			vector:= b - a.
			newPosition:= a + (vector * percent).
			newPosition:= newPosition + label extent.
			label position: newPosition ]]	
	
]

{ #category : #morphic }
DrmWidget >> createMorph [
	^ canvas createMorph
]

{ #category : #running }
DrmWidget >> createNodes: unModelo [
	| shapes labels |
	shapes := self model factors
		collect: [ :factor | self createRoassalNode: factor ]
		as: RSGroup.
	labels := shapes collect: [ :shape | shape propertyAt: #label ].
	canvas addAll: shapes.
	canvas addAll: labels.
	^ shapes
]

{ #category : #running }
DrmWidget >> createRoassalLabel: size for: unFactor [
	| shapeBuilder label |
	shapeBuilder := RSMultilineLabelBuilder new.
	shapeBuilder wrapStrategy: (RSWrapStrategy new wrapMaxWidth: size).
	label := shapeBuilder shapeFor: unFactor asString.
	^label
]

{ #category : #running }
DrmWidget >> createRoassalNode: factors [
	| label shape|
	label := self createRoassalLabel:100 for: factors.
	shape:= factors createBackground:self .
	shape draggable.
	shape propertyAt:#label put:label. 
	shape color: Color white.
	shape extent:120@80.
	shape model: factors.
	shape when:RSPositionChangedEvent do: [:evt | label position: shape position ]. 
	^shape
]

{ #category : #running }
DrmWidget >> createSupportBackground [
	^ RSShapeFactory hexagon
		withBorder;
		yourself
]

{ #category : #running }
DrmWidget >> initialize [
	super initialize.
	canvas:= RSCanvas new.
	
]

{ #category : #running }
DrmWidget >> model [
	^model
]

{ #category : #running }
DrmWidget >> model: anObject [
	| shapes edges |
	model := anObject.
	shapes := self createNodes: model.
	edges := self createEdges.
	self applyLayout: shapes edges: edges.
	canvas @ RSCanvasController
]

{ #category : #running }
DrmWidget >> open:unModelo [
	|shapes edges|
	shapes:= self createNodes:unModelo .
	edges:= self createEdges.
	self applyLayout:shapes edges:edges.
	canvas @ RSCanvasController.
	canvas inspect 

]

{ #category : #running }
DrmWidget >> run [
	<script: 'self new open:DrmModelBuilder figureTp'>
	
]

{ #category : #running }
DrmWidget >> runProfe [
	<script: 'self new open: DrmModelBuilder figureTwoDotSix'>
	
]
