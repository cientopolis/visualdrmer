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

{ #category : #accessing }
DrmDiagramPresenter >> model [
	^ model
]

{ #category : #accessing }
DrmDiagramPresenter >> model: anObject [
	model := anObject
]

{ #category : #running }
DrmDiagramPresenter >> run [
	<script: 'self new model: (DrmModelBuilder figureTp inspect; yourself); openWithSpec'>
]
