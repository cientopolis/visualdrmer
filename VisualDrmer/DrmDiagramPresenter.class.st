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
DrmDiagramPresenter >> addNodesTo: aCanvas [
	| shapes |
	shapes := model factors
		collect: [ :aFactor | self createRoassalNodeFor: aFactor ]
		as: RSGroup.
	aCanvas addAll: shapes
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> configureCanvas: canvas [
	model ifNil: [ ^ self ].
   self addNodesTo: canvas.
   self layout: canvas.
   canvas @ RSCanvasController.
 
]

{ #category : #'canvas configuration' }
DrmDiagramPresenter >> createRoassalNodeFor: aFactor [
	| shape |
	shape := RSEllipse new.
	shape draggable.
	shape color: Color white.
   shape border: RSBorder new.
   shape extent: 120 @ 80.
	shape model: aFactor.
	shape popup.
	^ shape
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
		on: aCanvas shapes.
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

{ #category : #announcements }
DrmDiagramPresenter >> nodeRemovedAnnouncement: aDrmNodeRemovedAnnouncement [
	diagram refresh
]

{ #category : #running }
DrmDiagramPresenter >> run [
	<script: 'self new model: (DrmModelBuilder figureTp inspect; yourself); openWithSpec'>
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
