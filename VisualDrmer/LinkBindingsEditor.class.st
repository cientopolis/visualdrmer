Class {
	#name : #LinkBindingsEditor,
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
LinkBindingsEditor class >> defaultSpec [
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
		yourself
]

{ #category : #specs }
LinkBindingsEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #accessing }
LinkBindingsEditor >> availableNodes: anObject [
	availableNodes := anObject asArray
]

{ #category : #initialization }
LinkBindingsEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		initialExtent: 600 @ 160;
		title: 'Editing the bindings of a link'.
	aDialog
		closeOnBackdropClick: true;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
LinkBindingsEditor >> initializePresenters [
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
LinkBindingsEditor >> model: aModel [
	"This makes no sense; the whole purpose of using my superclass was to get notified when my model changes but modelChanges is not triggered!"

	super model: aModel.
	self updateWidgetsFromModel
]

{ #category : #privatecallbacks }
LinkBindingsEditor >> updateModel [
	self model origin: originDropList selectedItem.
	self model levelAtOrigin: levelAtOriginDropList selectedItem.
	self model destination: destinationDropList selectedItem.
	self model
		levelAtDestination: levelAtDestinationDropList selectedItem.
	self model weight: weightDropList selectedItem
]

{ #category : #privatecallbacks }
LinkBindingsEditor >> updateWidgetsFromModel [
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
