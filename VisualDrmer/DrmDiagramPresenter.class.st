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
		'editLinkSourcesBlock',
		'editLinkBlock'
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
DrmDiagramPresenter >> configureShapeMenuesFor: canvas [
	(canvas nodes select: [ :each | each model notNil ])
		@
			(RSMenuActivable new
				menuDo: [ :menu :theShape | 
					menu
						add: 'Edit'
							target: self
							selector: #edit:
							argument: theShape model;
						add: 'Remove'
							target: self
							selector: #remove:
							argument: theShape model ])
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
			originLabel model: edge model.
			destinationLabel model: edge model.
			aCanvas
				add: originLabel;
				add: destinationLabel.
			self
				positionOriginLabel: originLabel
				destinationLabel: destinationLabel
				for: edge.
			edge
				when: RSExtentChangedEvent
				do: [ :evt | 
					self
						positionOriginLabel: originLabel
						destinationLabel: destinationLabel
						for: edge ] ]
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> drawMenuesOn: canvas [
	self configureShapeMenuesFor: canvas
	"configureLinkMenuesFor: canvas;
		configureNodeMenuesFor: canvas"
	"	configureCanvasMenuFor: canvas;"
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
					citationBodies
						nextPutAll: source citationLabel , ' ' , source citationBody ]
				separatedBy: [ citationBodies cr ].
			label := RSLabel new
				text: (citationLabels contents ifEmpty: [ '?' ]);
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
DrmDiagramPresenter >> edit: aShapeWithAModel [
	aShapeWithAModel class = DrmLink
		ifTrue: [ self editLink: aShapeWithAModel ]
		ifFalse: [ self editNode: aShapeWithAModel ]
]

{ #category : #'private-callbacks' }
DrmDiagramPresenter >> editLink: aDrmLink [
	editLinkBlock ifNil: [ ^ self ].
	editLinkBlock value: aDrmLink
]

{ #category : #accessing }
DrmDiagramPresenter >> editLinkBlock: anObject [
	editLinkBlock := anObject
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
		ifTrue: [ | border |
			form := DrmEllipse new.
			border := RSBorder new.
			aDrmNode isExternal
				ifTrue: [ border dashArray: #(4) ].
			aDrmNode isSuccessFactor | aDrmNode isMeasurableSuccessFactor
				| aDrmNode isKeyFactor
				ifTrue: [ border width: 3 ].
			form border: border ].
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
		bold;
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
	anObject ifNil: [ self error: 'Model should never be nil' ].
	model := anObject.
	self subscribeToModelAnnouncements.
	self refresh
]

{ #category : #'private-updating' }
DrmDiagramPresenter >> nodeAddedAnnouncement: aNodeAddedAnnouncement [
	self subscribeToNodeAnnouncementsOn: aNodeAddedAnnouncement subject.
	self refresh. 
]

{ #category : #'private-drawing' }
DrmDiagramPresenter >> positionOriginLabel: originLabel destinationLabel: destinationLabel for: edge [
	| startPoint endPoint vector |
	startPoint := edge startPoint.
	endPoint := edge endPoint.
	vector := endPoint - startPoint.
	originLabel position: startPoint + (vector * 0.125).
	^ destinationLabel position: endPoint - (vector * 0.125)
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
DrmDiagramPresenter >> remove: aShapeWithAModel [
	aShapeWithAModel class = DrmLink
		ifTrue: [ self removeLink: aShapeWithAModel ]
		ifFalse: [ self removeNode: aShapeWithAModel ]
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
		when: DrmLinkRemovedAnnouncement send: #refresh to: self;
		when: DrmModelSourcesChangedAnnouncement send: #refresh to: self.
	model sources
		do: [ :aSource | 
			aSource announcer
				when: DrmSourceChangedAnnouncement
				send: #refresh
				to: self ].
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
