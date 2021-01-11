Class {
	#name : #SupportEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'descriptionText',
		'titleTextInput'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
SupportEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: 'Title'
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #titleTextInput
					expand: true
					fill: true
					padding: 0;
				yourself)
			expand: false;
		add: 'Description'
			withConstraints: [ :constraints | constraints width: 80 ];
		add: #descriptionText
			expand: true
			fill: true
			padding: 5
]

{ #category : #specs }
SupportEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #initialization }
SupportEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		title: 'Editing support';
		closeOnBackdropClick: false;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
SupportEditor >> initializePresenters [
	titleTextInput := self newTextInput.
	descriptionText := self newText.
	self focusOrder
		addAll:
			{titleTextInput.
			descriptionText}
]

{ #category : #initialization }
SupportEditor >> model: aModel [
	super model: aModel.
	aModel ifNil: [ ^self ].
	self updateWidgetsFromModel
]

{ #category : #initialization }
SupportEditor >> updateModel [
	self model
		description:
			(descriptionText
				accept;
				text);
		title:
			(titleTextInput
				accept;
				text)
]

{ #category : #initialization }
SupportEditor >> updateWidgetsFromModel [
	descriptionText text: self model description.
	titleTextInput text: self model title
]
