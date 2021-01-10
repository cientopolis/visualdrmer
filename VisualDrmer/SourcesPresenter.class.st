Class {
	#name : #SourcesPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'sourcesList',
		'addAssumptionButton',
		'addReferenceButton',
		'removeButton',
		'editSelectedButton'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
SourcesPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #sourcesList;
		add:
			(SpBoxLayout newHorizontal
				addLast: #addAssumptionButton expand: false;
				addLast: #addReferenceButton expand: false;
				addLast: #editSelectedButton expand: false;
				addLast: #removeButton expand: false;
				yourself)
			expand: false;
		yourself
]

{ #category : #specs }
SourcesPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #callbacks }
SourcesPresenter >> addAssumption [
	| editor newSource |
	newSource := DrmAssumption new.
	editor := SourceEditor new
		model: newSource;
		yourself.
	editor openModalWithSpec.
	editor model ifNotNil: [ self model addSource: newSource ]
]

{ #category : #callbacks }
SourcesPresenter >> addReference [
	| editor newSource |
	newSource := DrmReference new.
	editor := SourceEditor new
		model: newSource;
		yourself.
	editor openModalWithSpec: #referenceSpec.
	editor model ifNotNil: [ self model addSource: newSource ]
]

{ #category : #initialization }
SourcesPresenter >> connectPresenters [
	sourcesList
		whenSelectionChangedDo: [ :evt | self updateWidgetsState ]
]

{ #category : #callbacks }
SourcesPresenter >> editSelected [
	| editor selectedSource |
	selectedSource := sourcesList selection selectedItem.
	selectedSource ifNil: [ ^ self ].
	editor := SourceEditor new
		model: selectedSource;
		yourself.
	selectedSource class = DrmReference
		ifTrue: [ editor openModalWithSpec: #referenceSpec ]
		ifFalse: [ editor openModalWithSpec ]
]

{ #category : #initialization }
SourcesPresenter >> initializePresenters [
	sourcesList := self newList
		display: [ :item | item citationLabel , ' ' , item citationBody ];
		beSingleSelection.
	addAssumptionButton := self newButton
		label: 'Add assumption';
		action: [ self addAssumption ];
		yourself.
	addReferenceButton := self newButton
		label: 'Add reference';
		action: [ self addReference ];
		yourself.
	editSelectedButton := self newButton
		label: 'Edit';
		action: [ self editSelected ];
		yourself.
	removeButton := self newButton
		label: 'Remove';
		action: [ self removeSelected ];
		yourself.
	self focusOrder
		addAll:
			{sourcesList.
			addAssumptionButton.
			addReferenceButton.
			removeButton.
			editSelectedButton}.
	self updateWidgetsFromModel
]

{ #category : #initialization }
SourcesPresenter >> initializeWindow: window [
	window
		initialExtent: 1200 @ 750
]

{ #category : #accessing }
SourcesPresenter >> model: aModel [
	"This makes no sense; the whole purpose of using my superclass was to get notified when my model changes but modelChanges is not triggered!"

	aModel ifNil: [ ^ self error: 'Model should not be nil' ].
	super model: aModel.
	self subscribeToModelAnnouncements.
	self updateWidgetsFromModel
]

{ #category : #announcements }
SourcesPresenter >> modelSourcesChangedAnnouncement [
	self subscribeToSourceAnnouncements.
	self updateWidgetsFromModel
]

{ #category : #callbacks }
SourcesPresenter >> removeSelected [
	self model
		sources: (self model sources copyWithout: sourcesList selection selectedItem)
]

{ #category : #announcements }
SourcesPresenter >> subscribeToModelAnnouncements [
	self model announcer
		when: DrmModelSourcesChangedAnnouncement
		send: #modelSourcesChangedAnnouncement
		to: self.
	self subscribeToSourceAnnouncements
]

{ #category : #announcements }
SourcesPresenter >> subscribeToSourceAnnouncements [
	self model sources
		do: [ :aSource | 
			aSource announcer
				when: DrmSourceChangedAnnouncement
				send: #updateWidgetsFromModel
				to: self ]
]

{ #category : #initialization }
SourcesPresenter >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	sourcesList items: self model sources.
	sourcesList selectItem: nil.
	self updateWidgetsState
]

{ #category : #initialization }
SourcesPresenter >> updateWidgetsState [
	sourcesList selection selectedItem
		ifNil: [ editSelectedButton disable.
			removeButton disable ]
		ifNotNil: [ editSelectedButton enable.
			removeButton enable ]
]
