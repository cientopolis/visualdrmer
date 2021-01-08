Class {
	#name : #LinkEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'originDropList',
		'levelAtOriginDropList',
		'destinationDropList',
		'levelAtDestinationDropList',
		'weightDropList',
		'availableNodes'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
LinkEditor class >> defaultSpec [
	^ SpGridLayout new
		beRowHomogeneous;
		add: 'Origin' at: 1 @ 1;
		add: #originDropList at: 2 @ 1;
		add: #levelAtOriginDropList at: 3 @ 1;
		add: 'Destination' at: 1 @ 2;
		add: #destinationDropList at: 2 @ 2;
		add: #levelAtDestinationDropList at: 3 @ 2;
		add: 'Weight' at: 1 @ 3;
		add: #weightDropList at: 2 @ 3;
		yourself
]

{ #category : #specs }
LinkEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #specs }
LinkEditor class >> title [
	^ 'Editing a node'
]

{ #category : #accessing }
LinkEditor >> availableNodes: anObject [
	availableNodes := anObject asArray
]

{ #category : #initialization }
LinkEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		closeOnBackdropClick: true;
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
	self updateWidgetsFromModel.
	self
		focusOrder addAll:
			{originDropList.
			levelAtOriginDropList.
			destinationDropList.
			levelAtDestinationDropList.
			weightDropList}
]

{ #category : #privatecallbacks }
LinkEditor >> model: aModel [
	"This makes no sense; the whole purpose of using my superclass was to get notified when my model changes but modelChanges is not triggered!"

	super model: aModel.
	self updateWidgetsFromModel
]

{ #category : #privatecallbacks }
LinkEditor >> updateModel [
	self model origin: originDropList selectedItem.
	self model levelAtOrigin: levelAtOriginDropList selectedItem.
	self model destination: destinationDropList selectedItem.
	self model
		levelAtDestination: levelAtDestinationDropList selectedItem.
	self model weight: weightDropList selectedItem
]

{ #category : #privatecallbacks }
LinkEditor >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	availableNodes ifNil: [ availableNodes := {nil} ].
	originDropList
		items: (availableNodes copyWith: nil);
		selectItem: self model origin.
	levelAtOriginDropList
		items: {'?' . '+' . '-'};
		selectItem: self model levelAtOrigin.
	destinationDropList
		items: (availableNodes copyWith: nil);
		selectItem: self model destination.
	levelAtDestinationDropList
		items: {'?' . '+' . '-'};
		selectItem: self model levelAtDestination.
	weightDropList
		items: {1 . 2 . 3};
		selectItem: self model weight
]
