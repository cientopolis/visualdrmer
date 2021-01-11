Class {
	#name : #DetailsEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'authorTextInput',
		'titleTextInput',
		'isReferenceModelButton',
		'isImpactModelButton',
		'notesText'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DetailsEditor class >> defaultSpec [
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
		add:
			(SpBoxLayout newHorizontal
					add: 'Author'
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #authorTextInput
						expand: true
						fill: true
						padding: 0;
					yourself)
			expand: false
			fill: false
			padding: 5;
		add:
			(SpBoxLayout newHorizontal
					add: 'Type'
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #isReferenceModelButton;
					add: #isImpactModelButton;
					yourself)
			expand: false
			fill: false
			padding: 5;
		add: 'Notes'
			withConstraints: [ :constraints | constraints width: 80 ];
		add: #notesText
			expand: true
			fill: true
			padding: 0
]

{ #category : #specs }
DetailsEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #specs }
DetailsEditor class >> title [
	^ 'About this model'
]

{ #category : #initialization }
DetailsEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		title: 'Document details';
		closeOnBackdropClick: false;
		okAction: [ :presenter | self updateModel ]
]

{ #category : #initialization }
DetailsEditor >> initializePresenters [
	authorTextInput := self newTextInput.
	titleTextInput := self newTextInput.
	notesText := self newText.
	isReferenceModelButton := self newRadioButton
		label: 'Reference model';
		yourself.
	isImpactModelButton := self newRadioButton
		label: 'Impact model';
		yourself.
	isReferenceModelButton associatedRadioButtons: {isImpactModelButton}.
	self focusOrder
		addAll:
			{authorTextInput.
			titleTextInput.
			isReferenceModelButton.
			isImpactModelButton.
			notesText}.

]

{ #category : #initialization }
DetailsEditor >> model: aDrmModel [
	super model: aDrmModel.
	self updateWidgetsFromModel
]

{ #category : #initialization }
DetailsEditor >> updateModel [
	self model
		author:
			(authorTextInput
				accept;
				text).
	self model
		title:
			(titleTextInput
				accept;
				text).
	self model
		notes:
			(notesText
				accept;
				text).
	isReferenceModelButton state
		ifTrue: [ self model beReferenceModel ]
		ifFalse: [ self model beImpactModel ]
]

{ #category : #initialization }
DetailsEditor >> updateWidgetsFromModel [
	authorTextInput text: self model author.
	titleTextInput text: self model title.
	notesText text: self model notes.
	isImpactModelButton state: self model isImpactModel
]
