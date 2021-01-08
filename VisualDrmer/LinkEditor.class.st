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
	availableNodes := anObject
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

{ #category : #initialization }
LinkEditor >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	originDropList
		items: (availableNodes copyWith: nil);
		selectedItem: self model origin.
	levelAtOriginDropList
		items: {'?' . '+' . '-'};
		selectedItem: self model levelAtOrigin.
	destinationDropList
		items: (availableNodes copyWith: nil);
		selectedItem: self model destination.
	levelAtDestinationDropList
		items: {'?' . '+' . '-'};
		selectedItem: self model levelAtDestination.
	weightDropList
		items: {1 . 2 . 3};
		selectedItem: self model weight
]
