Class {
	#name : #DrmModelPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'#tabManager',
		'#model => SpObservableSlot'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmModelPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #tabManager;
		yourself
]

{ #category : #examples }
DrmModelPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
DrmModelPresenter class >> title [
	^ 'Dremer'
]

{ #category : #initialization }
DrmModelPresenter >> formTab [
	^ SpNotebookPage
		title: 'Details'
		icon: (self iconNamed: #glamorousBrowse)
		provider: [ self newText
				text: 'Formulario';
				yourself ]
]

{ #category : #initialization }
DrmModelPresenter >> initialize [
	super initialize.
	model := DrmModelBuilder figureTwoDotSix.
	self property: #model whenChangedDo: [ self updateModel ]
]

{ #category : #initialization }
DrmModelPresenter >> initializePresenters [
	tabManager := self newNotebook.
	tabManager
		addPage: self roassalTab;
		addPage: self formTab
]

{ #category : #initialization }
DrmModelPresenter >> roassalTab [
	^ SpNotebookPage
		title: 'Diagram'
		icon: (self iconNamed: #objects)
		provider: [ self newMorph
				morph: self roassalWidget;
				yourself ]
]

{ #category : #private }
DrmModelPresenter >> roassalWidget [
	^ DrmWidget new
		model: model;
		createMorph
]

{ #category : #accessing }
DrmModelPresenter >> tabManager [
	^ tabManager
]

{ #category : #accessing }
DrmModelPresenter >> tabManager: anObject [
	tabManager := anObject
]

{ #category : #updating }
DrmModelPresenter >> updateModel [
	self .
]
