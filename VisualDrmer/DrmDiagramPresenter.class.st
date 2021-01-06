Class {
	#name : #DrmDiagramPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'diagram'
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

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> addEdgesTo: canvas [
	| marker |
	marker := RSShapeFactory arrow.
	marker size: 10.
	RSEdgeBuilder line
		attachPoint:
			(RSBorderAttachPoint new
				endOffset: 5;
				yourself);
		canvas: canvas;
		markerEnd: marker;
		source: model links
			connectFrom: [ :link | link origin ]
			to: [ :link | link destination ]
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> addNodesTo: aCanvas [
	| shapes |
	shapes := model factors
		collect: [ :aFactor | self nodeFor: aFactor ]
		as: RSGroup.
	aCanvas addAll: shapes
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> configureCanvas: canvas [
	model ifNil: [ ^ self ].
   self addNodesTo: canvas.
   self addEdgesTo: canvas.
   self layout: canvas.
   canvas @ RSCanvasController.
   canvas nodes when: RSMouseClick do: [ :evt | evt shape inspect ].
 
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> formFor: aFactor [
	| form |
	aFactor class == DrmFactor
		ifTrue: [ form := RSEllipse new.
			form
				border:
					(aFactor isExternal
						ifTrue: [ RSBorder new dashArray: #(4) ]
						ifFalse: [ RSBorder new ]) ].
	aFactor class == DrmSupport
		ifTrue: [ form := RSShapeFactory hexagon.
			form border: RSBorder new ].
	form
		color: Color white;
		extent: 120 @ 80.
	^ form
]

{ #category : #initialization }
DrmDiagramPresenter >> initializePresenters [
	diagram := self instantiate: SpRoassalPresenter .
	diagram script: [ :canvas | self configureCanvas: canvas ].
]

{ #category : #layouting }
DrmDiagramPresenter >> layout: aCanvas [
	RSForceBasedLayout new
		charge: -700;
		on: aCanvas nodes.
	aCanvas zoomToFit
]

{ #category : #announcements }
DrmDiagramPresenter >> linkAddedAnnouncement: aDrmLinkAddedAnnouncement [
	aDrmLinkAddedAnnouncement subject announcer
		when: aDrmLinkAddedAnnouncement
		send: #linkChangedAnnouncement:
		to: self.
	diagram refresh. 
]

{ #category : #announcements }
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

{ #category : #announcements }
DrmDiagramPresenter >> nodeAddedAnnouncement: aDrmNodeAddedAnnouncement [
	aDrmNodeAddedAnnouncement subject announcer
		when: DrmNodeChangedAnnouncement
		send: #nodeChangedAnnouncement:
		to: self.
	diagram refresh
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> nodeFor: aFactor [
	"Inspired on the class comment of RSComposite"

	| form label shape labelBuilder |
	form := self formFor: aFactor.
	labelBuilder := RSMultilineLabelBuilder new.
	labelBuilder wrapStrategy: (RSWrapStrategy new wrapMaxWidth: 100).
	label := labelBuilder shapeFor: aFactor printString.
	RSLocation new
		middle;
		center;
		move: form on: label.
	shape := RSComposite new.
	shape model: aFactor.
	shape
		shapes:
			{form.
			label}.
	^ shape @ RSDraggable
]

{ #category : #announcements }
DrmDiagramPresenter >> nodeRemovedAnnouncement: aDrmNodeRemovedAnnouncement [
	diagram refresh
]

{ #category : #running }
DrmDiagramPresenter >> run [
	<script: 'self new model: (DrmModelBuilder figureTp); openWithSpec'>
]

{ #category : #announcements }
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
