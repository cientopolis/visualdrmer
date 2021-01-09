Class {
	#name : #DrmDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'diagram',
		'addNodeBlock',
		'removeNodeBlock',
		'editNodeBlock',
		'addLinkBlock',
		'removeLinkBlock',
		'editLinkBindingsBlock',
		'editLinkSourcesBlock'
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

{ #category : #constants }
DrmDiagramPresenter class >> lineWidths [
	^ {1 . 2 . 3}
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> addFactor [
	addNodeBlock ifNil: [ ^ self ].
	addNodeBlock value
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> addLink [
	addLinkBlock ifNil: [ ^ self ].
	addLinkBlock value
]

{ #category : #accessing }
DrmDiagramPresenter >> addLinkBlock: anObject [
	addLinkBlock := anObject
]

{ #category : #accessing }
DrmDiagramPresenter >> addNodeBlock: anObject [
	addNodeBlock := anObject
]

{ #category : #api }
DrmDiagramPresenter >> autoLayout [
	RSForceBasedLayout new
		charge: -10000;
		on: (diagram canvas nodes select: [ :each | each model notNil ]).
	diagram canvas zoomToFit.
	diagram refresh
]

{ #category : #'private-menus' }
DrmDiagramPresenter >> configureCanvasMenuFor: canvas [
	canvas
		@
			(RSMenuActivable new
				menuDo: [ :menu :theCanvas | 
					menu
						add: 'Layout'
							target: self
							selector: #layout:
							argument: theCanvas;
						add: 'Zoom to fit'
							target: self
							selector: #zoomToFit
							argument: #();
						addLine;
						add: 'Add factor'
							target: self
							selector: #addFactor
							argument: #();
						add: 'Add link'
							target: self
							selector: #addLink
							argument: #() ])
]

{ #category : #'private-menus' }
DrmDiagramPresenter >> configureLinkMenuesFor: canvas [
	(canvas edges select: [ :each | each model notNil ])
		@
			(RSMenuActivable new
				menuDo: [ :menu :theLink | 
					menu
						add: 'Edit sources'
							target: self
							selector: #editLinkSources:
							argument: theLink model;
						add: 'Edit bindings'
							target: self
							selector: #editLinkBindings:
							argument: theLink model;
						add: 'Remove'
							target: self
							selector: #removeLink:
							argument: theLink model ])
]

{ #category : #'private-menus' }
DrmDiagramPresenter >> configureNodeMenuesFor: canvas [
	(canvas nodes select: [ :each | each model notNil ])
		@
			(RSMenuActivable new
				menuDo: [ :menu :theFactor | 
					menu
						add: 'Edit'
							target: self
							selector: #editNode:
							argument: theFactor model;
						add: 'Remove'
							target: self
							selector: #removeNode:
							argument: theFactor model ])
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawEdgesOn: canvas [
	| edgeBuilder edge originShape destinationShape |
	edgeBuilder := RSEdgeBuilder line
		withBorderAttachPoint;
		canvas: canvas;
		markerEnd:
			(RSShapeFactory arrow
				size: 13;
				yourself).
	model links
		do: [ :link | 
			originShape := canvas nodes
				detect: [ :each | each model == link origin ].
			destinationShape := canvas nodes
				detect: [ :each | each model == link destination ].
			edge := edgeBuilder edgeFrom: originShape to: destinationShape.
			edge
				width: (self class lineWidths at: link weight);
				model: link ]
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawLevelLabelsOn: aCanvas [
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
DrmDiagramPresenter >> drawMenuesOn: canvas [
	self
		configureCanvasMenuFor: canvas;
		configureLinkMenuesFor: canvas;
		configureNodeMenuesFor: canvas
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawNodeLabelsOn: aCanvas [
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
DrmDiagramPresenter >> drawNodesOn: aCanvas [
	| shapes |
	shapes := model factors
		collect: [ :aFactor | self shapeForNode: aFactor ]
		as: RSGroup.
	aCanvas addAll: shapes
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawOn: canvas [
	model ifNil: [ ^ self ].
	self
		drawNodesOn: canvas;
		drawEdgesOn: canvas;
		drawNodeLabelsOn: canvas;
		drawLevelLabelsOn: canvas;
		drawSourcesLabelsOn: canvas.
	canvas @ RSCanvasController.

]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawSourcesLabelsOn: aCanvas [
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
				text: (citationLabels contents ifEmpty: ['?']);
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

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> editLinkBindings: aDrmLink [
	editLinkBindingsBlock ifNil: [ ^ self ].
	editLinkBindingsBlock value: aDrmLink
]

{ #category : #accessing }
DrmDiagramPresenter >> editLinkBindingsBlock: anObject [
	editLinkBindingsBlock := anObject
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> editLinkSources: aDrmLink [
	editLinkSourcesBlock ifNil: [ ^ self ].
	editLinkSourcesBlock value: aDrmLink
]

{ #category : #accessing }
DrmDiagramPresenter >> editLinkSourcesBlock: anObject [
	editLinkSourcesBlock := anObject
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> editNode: aDrmNode [
	editNodeBlock ifNil: [ ^ self ].
	editNodeBlock value: aDrmNode
]

{ #category : #accessing }
DrmDiagramPresenter >> editNodeBlock: anObject [
	editNodeBlock := anObject
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> figureForNode: aDrmNode [
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
			self drawMenuesOn: canvas ]
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
		text: aValue;
		yourself.
	^ RSComposite new
		shapes: {label};
		padding: 2;
		color: Color white;
		yourself
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> layout: aCanvas [
	self autoLayout
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> linkAddedAnnouncement: aDrmLinkAddedAnnouncement [
	self subscribeToLinkAnnouncementsOn: aDrmLinkAddedAnnouncement subject.
	self refresh.
]

{ #category : #accessing }
DrmDiagramPresenter >> model [
	^ model
]

{ #category : #accessing }
DrmDiagramPresenter >> model: anObject [
	model := anObject.
	model ifNotNil: [ self subscribeToModelAnnouncements ].
	self refresh
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> nodeAddedAnnouncement: aNodeAddedAnnouncement [
	self subscribeToNodeAnnouncementsOn: aNodeAddedAnnouncement subject.
	self refresh. 
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> refresh [
	| cameraPosition cameraScale |
	diagram canvas ifNil: [ ^ self ].
	cameraPosition := diagram canvas camera position.
	cameraScale := diagram canvas camera scale.
	diagram refresh.
	diagram canvas camera position: cameraPosition.
	diagram canvas camera scale: cameraScale
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> removeLink: aDrmLink [
	removeLinkBlock ifNil: [ ^ self ].
	removeLinkBlock value: aDrmLink
]

{ #category : #accessing }
DrmDiagramPresenter >> removeLinkBlock: anObject [
	removeLinkBlock := anObject
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> removeNode: aDrmNode [
	removeNodeBlock ifNil: [ ^ self ].
	removeNodeBlock value: aDrmNode
]

{ #category : #accessing }
DrmDiagramPresenter >> removeNodeBlock: anObject [
	removeNodeBlock := anObject
]

{ #category : #running }
DrmDiagramPresenter >> run [
	<script: 'self new model: (DrmModelBuilder figureTp); openWithSpec'>
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> shapeForNode: aFactor [
	| form |
	form := self figureForNode: aFactor.
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
DrmDiagramPresenter >> subscribeToLinkAnnouncementsOn: aLink [
	aLink announcer when: DrmLinkChangedAnnouncement send: #refresh to: self
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> subscribeToModelAnnouncements [
	model announcer
		when: DrmNodeAddedAnnouncement
			send: #nodeAddedAnnouncement:
			to: self;
		when: DrmNodeRemovedAnnouncement send: #refresh to: self;
		when: DrmLinkAddedAnnouncement
			send: #linkAddedAnnouncement:
			to: self;
		when: DrmLinkRemovedAnnouncement send: #refresh to: self.
	model nodes
		do: [ :aNode | self subscribeToNodeAnnouncementsOn: aNode ].
	model links
		do: [ :aLink | self subscribeToLinkAnnouncementsOn: aLink ]
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> subscribeToNodeAnnouncementsOn: aNode [
	aNode announcer when: DrmNodeChangedAnnouncement send: #refresh to: self
]

{ #category : #api }
DrmDiagramPresenter >> zoomToFit [
	diagram canvas zoomToFit
]
