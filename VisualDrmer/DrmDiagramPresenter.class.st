Class {
	#name : #DrmDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'diagram',
		'addNodeBlock',
		'removeNodeBlock',
		'editNodeBlock'
	],
	#category : #'VisualDrmer-RoassalWidget'
}

{ #category : #specs }
DrmDiagramPresenter class >> defaultSpec [ 
	<spec: #default>
	^ SpBoxLayout newHorizontal 
		add: #diagram ;
		yourself
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addEdgesTo: canvas [
	| edgeBuilder edge originShape destinationShape |
	edgeBuilder := RSEdgeBuilder line
		withBorderAttachPoint;
		canvas: canvas;
		markerEnd:
			(RSShapeFactory arrow
				size: 10;
				yourself).
	model links
		do: [ :link | 
			originShape := canvas nodes
				detect: [ :each | each model == link origin ].
			destinationShape := canvas nodes
				detect: [ :each | each model == link destination ].
			edge := edgeBuilder edgeFrom: originShape to: destinationShape.
			edge model: link ]
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> addFactor [
	addNodeBlock ifNil: [ ^ self ].
	addNodeBlock value
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addLevelLabelsTo: aCanvas [
	aCanvas edges
		do: [ :edge | 
			| originLabel destinationLabel |
			originLabel := self labelForLevel: edge model levelAtOrigin.
			destinationLabel := self
				labelForLevel: edge model levelAtDestination.
			aCanvas
				add: originLabel;
				add: destinationLabel.
			edge
				when: RSExtentChangedEvent
				do: [ :evt | 
					| startPoint endPoint vector |
					startPoint := edge startPoint.
					endPoint := edge endPoint.
					vector := endPoint - startPoint.
					originLabel position: startPoint + (vector * 0.125).
					destinationLabel position: endPoint - (vector * 0.125) ] ]
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addMenuesTo: canvas [
	self
		configureCanvasMenuFor: canvas;
		configureNodeMenuesFor: canvas
]

{ #category : #accessing }
DrmDiagramPresenter >> addNodeBlock [
	^ addNodeBlock
]

{ #category : #accessing }
DrmDiagramPresenter >> addNodeBlock: anObject [
	addNodeBlock := anObject
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addNodeLabelsTo: aCanvas [
	| labelBuilder label |
	labelBuilder := RSMultilineLabelBuilder new.
	labelBuilder wrapStrategy: (RSWrapStrategy new wrapMaxWidth: 100).
	aCanvas nodes
		do: [ :aNode | 
			label := labelBuilder shapeFor: aNode model printString.
			aCanvas add: label.
			RSLocation new
				middle;
				center;
				stick: label on: aNode ]
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addNodesTo: aCanvas [
	| shapes |
	shapes := model factors
		collect: [ :aFactor | self nodeFor: aFactor ]
		as: RSGroup.
	aCanvas addAll: shapes
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> addSourcesLabelsTo: aCanvas [
	| composite |
	aCanvas edges
		do: [ :edge | 
			| label citationLabels citationBodies |
			citationLabels := String new writeStream.
			citationBodies := String new writeStream.
			edge model sources
				do: [ :source | 
					citationLabels nextPutAll: source citationLabel.
					citationBodies nextPutAll: source citationBody ]
				separatedBy: [ citationBodies cr ].
			label := RSLabel new
				text: citationLabels contents;
				yourself.
			label
				@
					(RSMorphicPopup new
						morphBuilder: [ :labelModel | citationBodies contents asTextMorph ]).
			composite := RSComposite new
				shapes: {label};
				padding: 2;
				color: Color white;
				yourself.
			aCanvas add: composite.
			RSLocation new
				middle;
				center;
				stick: composite on: edge ]
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> configureCanvasMenuFor: canvas [
	canvas
		@
			(RSMenuActivable new
				menuDo: [ :menu :theCanvas | 
					menu
						add: 'Layout'
						target: self
						selector: #layout:
						argument: theCanvas.
					menu
						add: 'Zoom to fit'
						target: theCanvas
						selector: #zoomToFit
						argument: #().
					menu addLine.
					menu
						add: 'Add factor'
						target: self
						selector: #addFactor
						argument: #() ])
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> configureNodeMenuesFor: canvas [
	(canvas nodes select: [ :each | each model notNil ])
		@
			(RSMenuActivable new
				menuDo: [ :menu :theFactor | 
					menu
						add: 'Remove'
						target: self
						selector: #remove:
						argument: theFactor ])
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawOn: canvas [
	model ifNil: [ ^ self ].
	self
		addNodesTo: canvas;
		addEdgesTo: canvas;
		addNodeLabelsTo: canvas;
		addLevelLabelsTo: canvas;
		addSourcesLabelsTo: canvas.
	canvas @ RSCanvasController.

]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> editNode: aNodeShape [
	editNodeBlock ifNil: [ ^ self ].
	editNodeBlock value: aNodeShape model
]

{ #category : #accessing }
DrmDiagramPresenter >> editNodeBlock [
	^ editNodeBlock
]

{ #category : #accessing }
DrmDiagramPresenter >> editNodeBlock: anObject [
	editNodeBlock := anObject
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> formForNode: aDrmNode [
	| form |
	aDrmNode class == DrmFactor
		ifTrue: [ form := DrmEllipse new.
			form
				border:
					(aDrmNode isExternal
						ifTrue: [ RSBorder new dashArray: #(4) ]
						ifFalse: [ RSBorder new ]) ].
	aDrmNode class == DrmSupport
		ifTrue: [ form := RSShapeFactory hexagon.
			form border: RSBorder new ].
	form
		color: Color white;
		extent: 120 @ 80.
	^ form
]

{ #category : #initialization }
DrmDiagramPresenter >> initializePresenters [
	diagram := self instantiate: SpRoassalPresenter.
	diagram
		script: [ :canvas | 
			self drawOn: canvas.
			self addMenuesTo: canvas ]
]

{ #category : #initialization }
DrmDiagramPresenter >> initializeWindow: window [
	window
		title: 'Test';
		initialExtent: 1200 @ 750
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> labelForLevel: aValue [
	| label |
	label := RSLabel new
		text:
			(aValue < 0
				ifTrue: [ '-' ]
				ifFalse: [ aValue = 0
						ifTrue: [ '?' ]
						ifFalse: [ '+' ] ]);
		yourself.
	^ RSComposite new
		shapes: {label};
		padding: 2;
		color: Color white;
		yourself
]

{ #category : #'private-layouting' }
DrmDiagramPresenter >> layout: aCanvas [
	RSForceBasedLayout new
		charge: -10000;
		on: (aCanvas nodes select: [ :each | each model notNil ]).
	aCanvas zoomToFit
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> linkAddedAnnouncement: aDrmLinkAddedAnnouncement [
	aDrmLinkAddedAnnouncement subject announcer
		when: aDrmLinkAddedAnnouncement
		send: #linkChangedAnnouncement:
		to: self.
	diagram refresh. 
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> linkRemovedAnnouncement: aDrmLinkRemovedAnnouncement [
	diagram refresh. 
]

{ #category : #accessing }
DrmDiagramPresenter >> model [
	^ model
]

{ #category : #accessing }
DrmDiagramPresenter >> model: anObject [
	model := anObject.
	self subscribeToModelAnnouncements
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> nodeAddedAnnouncement: aDrmNodeAddedAnnouncement [
	aDrmNodeAddedAnnouncement subject announcer
		when: DrmNodeChangedAnnouncement
		send: #nodeChangedAnnouncement:
		to: self.
	diagram refresh
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> nodeFor: aFactor [
	| form |
	form := self formForNode: aFactor.
	form model: aFactor.
	aFactor propertiesDictionary
		at: #position
		ifPresent: [ :position | form position: position ].
	form
		when: RSPositionChangedEvent
		do: [ form model propertiesDictionary at: #position put: form position ].
	^ form @ RSDraggable
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> nodeRemovedAnnouncement: aDrmNodeRemovedAnnouncement [
	diagram refresh
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> remove: aNodeShape [
	removeNodeBlock ifNil: [ ^ self ].
	removeNodeBlock value: aNodeShape model
]

{ #category : #accessing }
DrmDiagramPresenter >> removeNodeBlock [
	^ removeNodeBlock
]

{ #category : #accessing }
DrmDiagramPresenter >> removeNodeBlock: anObject [
	removeNodeBlock := anObject
]

{ #category : #running }
DrmDiagramPresenter >> run [
	<script: 'self new model: (DrmModelBuilder figureTp); openWithSpec'>
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> subscribeToModelAnnouncements [
	model announcer
		when: DrmNodeAddedAnnouncement
			send: #nodeAddedAnnouncement:
			to: self;
		when: DrmLinkAddedAnnouncement
			send: #linkAddedAnnouncement:
			to: self;
		when: DrmNodeRemovedAnnouncement
			send: #nodeRemovedAnnouncement:
			to: self;
		when: DrmLinkRemovedAnnouncement
			send: #linkRemovedAnnouncement:
			to: self
]
