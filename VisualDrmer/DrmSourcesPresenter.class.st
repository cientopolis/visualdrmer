Class {
	#name : #DrmSourcesPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'sourcesList',
		'addAssumptionButton',
		'addReferenceButton',
		'removeButton',
		'relabelButton'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmSourcesPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: 'Sources' expand: false;
		add: #sourcesList;
		add:
			(SpBoxLayout newHorizontal
				addLast: #addAssumptionButton expand: false;
				addLast: #addReferenceButton expand: false;
				addLast: #removeButton expand: false;
				addLast: #relabelButton expand: false;
				yourself)
			expand: false;
		yourself
]

{ #category : #specs }
DrmSourcesPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
DrmSourcesPresenter >> connectPresenters [
	sourcesList
		whenSelectionChangedDo: [ :evt | self updateWidgetsState ]
]

{ #category : #initialization }
DrmSourcesPresenter >> initializePresenters [
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
	removeButton := self newButton
		label: 'Remove';
		action: [ self removeSelected ];
		yourself.
	relabelButton := self newButton
		label: 'Relabel';
		action: [ self relabelSources ];
		yourself.
	self focusOrder
		addAll:
			{sourcesList.
			addAssumptionButton.
			addReferenceButton.
			removeButton.
			relabelButton}.
	self updateWidgetsFromModel
]

{ #category : #initialization }
DrmSourcesPresenter >> initializeWindow: window [
	window
		initialExtent: 1200 @ 750
]

{ #category : #accessing }
DrmSourcesPresenter >> model: aModel [
	"This makes no sense; the whole purpose of using my superclass was to get notified when my model changes but modelChanges is not triggered!"

	super model: aModel.
	self updateWidgetsFromModel
]

{ #category : #initialization }
DrmSourcesPresenter >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	sourcesList items: self model sources.
	self updateWidgetsState
]

{ #category : #initialization }
DrmSourcesPresenter >> updateWidgetsState [
	sourcesList selection selectedItem
		ifNil: [ removeButton disable ]
		ifNotNil: [ removeButton enable ]
]
