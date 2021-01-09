Class {
	#name : #LinkEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'originDropList',
		'levelAtOriginDropList',
		'destinationDropList',
		'levelAtDestinationDropList',
		'weightDropList',
		'sourcesList',
		'sourcesToAddDropList',
		'removeSourceButton',
		'drmModel'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
LinkEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: 'Origin: '
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #originDropList
					expand: true
					fill: true
					padding: 0;
				add: #levelAtOriginDropList
					withConstraints: [ :constraints | constraints width: 60 ];
				yourself)
			expand: false;
		add:
			(SpBoxLayout newHorizontal
					add: 'Destination: '
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #destinationDropList
						expand: true
						fill: true
						padding: 0;
					add: #levelAtDestinationDropList
						withConstraints: [ :constraints | constraints width: 60 ];
					yourself)
			expand: false
			fill: false
			padding: 5;
		add:
			(SpBoxLayout newHorizontal
				add: 'Weight:'
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #weightDropList
					withConstraints: [ :constraints | constraints width: 60 ];
				yourself)
			expand: false;
		add: 'Sources:'
			withConstraints: [ :constraints | 
			constraints
				width: 80;
				expand: false;
				padding: 5 ];
		add: #sourcesList;
		add:
			(SpBoxLayout newHorizontal
					add: #removeSourceButton
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #sourcesToAddDropList;
					yourself)
			expand: false
			fill: false
			padding: 5;
		yourself
]

{ #category : #specs }
LinkEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #private }
LinkEditor >> availableNodes [
	drmModel ifNil: [ ^ Array new ].
	^ drmModel nodes
		asSortedCollection: [ :a :b | a printString < b printString ]
]

{ #category : #initialization }
LinkEditor >> connectPresenters [
	originDropList
		whenSelectedItemChangedDo: [ :evt | 
			destinationDropList
				items: (self availableNodes copyWithout: originDropList selectedItem);
				selectItem: nil ].
	sourcesList
		whenSelectionChangedDo: [ :evt | 
			sourcesList selection selectedItem
				ifNil: [ removeSourceButton disable ]
				ifNotNil: [ removeSourceButton enable ] ].
	sourcesToAddDropList
		whenSelectedItemChangedDo: [ :evt | 
			| selection |
			selection := sourcesToAddDropList selectedItem.
			selection
				ifNotNil: [ sourcesList items: (sourcesList items copyWith: selection) ] ]
]

{ #category : #accessing }
LinkEditor >> drmModel: aDrmModel [
	drmModel := aDrmModel.
	self updateWidgetsFromModel
]

{ #category : #initialization }
LinkEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		initialExtent: 600 @ 400;
		title: 'Editing the bindings of a link';
		closeOnBackdropClick: false;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
LinkEditor >> initializePresenters [
	originDropList := self newDropList.
	levelAtOriginDropList := self newDropList.
	destinationDropList := self newDropList.
	levelAtDestinationDropList := self newDropList.
	weightDropList := self newDropList.
	sourcesList := self newList
		display: [ :item | item citationLabel , '' , item citationBody ];
		beSingleSelection;
		yourself.
	sourcesToAddDropList := self newDropList
		display: [ :item | item citationLabel , '' , item citationBody ];
		startWithoutSelection;
		yourself.
	removeSourceButton := self newButton
		label: 'Remove';
		action: [ self removeSelectedSource ];
		disable;
		yourself.
	self focusOrder
		addAll:
			{originDropList.
			levelAtOriginDropList.
			destinationDropList.
			levelAtDestinationDropList.
			weightDropList.
			sourcesList.
			removeSourceButton.
			sourcesToAddDropList}
]

{ #category : #initialization }
LinkEditor >> model: aModel [
	"This makes no sense; the whole purpose of using my superclass was to get notified when my model changes but modelChanges is not triggered!"

	super model: aModel.
	aModel ifNil: [ ^ self ].
	self updateWidgetsFromModel
]

{ #category : #initialization }
LinkEditor >> removeSelectedSource [
	| selectedItem |
	selectedItem := sourcesList selection selectedItem.
	sourcesList items: (sourcesList items copyWithout: selectedItem)
]

{ #category : #private }
LinkEditor >> updateModel [
	self model origin: originDropList selectedItem.
	self model levelAtOrigin: levelAtOriginDropList selectedItem.
	self model destination: destinationDropList selectedItem.
	self model
		levelAtDestination: levelAtDestinationDropList selectedItem.
	self model weight: weightDropList selectedItem.
	self model sources: sourcesList items.
]

{ #category : #private }
LinkEditor >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	drmModel ifNil: [ ^ self ].
	originDropList
		items: self availableNodes;
		selectItem: self model origin.
	levelAtOriginDropList
		items: {'?' . '+' . '-'};
		selectItem: self model levelAtOrigin.
	destinationDropList
		items: self availableNodes;
		selectItem: self model destination.
	levelAtDestinationDropList
		items: {'?' . '+' . '-'};
		selectItem: self model levelAtDestination.
	weightDropList
		items: {1 . 2 . 3};
		selectItem: self model weight.
	sourcesList items: self model sources.
	sourcesToAddDropList
		items: (drmModel sources copyWithoutAll: sourcesList items)
]
