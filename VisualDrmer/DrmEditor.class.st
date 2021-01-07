Class {
	#name : #DrmEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'#tabManager',
		'#model => SpObservableSlot'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #tabManager;
		yourself
]

{ #category : #examples }
DrmEditor class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
DrmEditor class >> title [
	^ 'Dremer'
]

{ #category : #initialization }
DrmEditor >> formTab [
	^ SpNotebookPage
		title: 'Details'
		icon: (self iconNamed: #glamorousBrowse)
		provider: [ self newText
				text: 'Formulario';
				yourself ]
]

{ #category : #initialization }
DrmEditor >> initialize [
	super initialize.
	model := DrmModelBuilder figureTwoDotSix.
	self property: #model whenChangedDo: [ self updateModel ]
]

{ #category : #initialization }
DrmEditor >> initializePresenters [
	tabManager := self newNotebook.
	tabManager
		addPage: self roassalTab;
		addPage: self formTab
]

{ #category : #initialization }
DrmEditor >> initializeWindow: window [
	window
		title: 'Drmer';
		initialExtent: 1200 @ 750
]

{ #category : #initialization }
DrmEditor >> roassalTab [
	^ SpNotebookPage
		title: 'Diagram'
		icon: (self iconNamed: #objects)
		provider: [ | presenter |
			presenter := self instantiate: DrmDiagramPresenter.
			presenter model: model ]
]

{ #category : #private }
DrmEditor >> roassalWidget [
	^ DrmDiagramPresenter new
		model: model;
		createMorph
]

{ #category : #accessing }
DrmEditor >> tabManager [
	^ tabManager
]

{ #category : #accessing }
DrmEditor >> tabManager: anObject [
	tabManager := anObject
]

{ #category : #updating }
DrmEditor >> updateModel [
	self .
]
