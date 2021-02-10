Class {
	#name : #SourceEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'notesText',
		'labelTextInput',
		'citationText'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
SourceEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: 'Notes'
			withConstraints: [ :constraints | constraints width: 80 ];
		add: #notesText
			expand: true
			fill: true
			padding: 0;
		yourself
]

{ #category : #examples }
SourceEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #examples }
SourceEditor class >> openAsReference [
	<example>
	^ self new openModalWithSpec: #referenceSpec
]

{ #category : #specs }
SourceEditor class >> referenceSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: 'Label'
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #labelTextInput
					expand: true
					fill: true
					padding: 0;
				yourself)
			expand: false;
		add:
			(SpBoxLayout newVertical
					add: 'Citation (APA Style)'
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #citationText
						expand: true
						fill: true
						padding: 0;
					yourself)
			expand: true
			fill: true
			padding: 5;
		add: 'Notes'
			withConstraints: [ :constraints | constraints width: 80 ];
		add: #notesText
			expand: true
			fill: true
			padding: 0
]

{ #category : #initialization }
SourceEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		title: 'Editing the a source';
		closeOnBackdropClick: false;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
SourceEditor >> initializePresenters [
	notesText := self newText.
	labelTextInput := self newTextInput.
	citationText := self newText.
	self focusOrder
		addAll:
			{labelTextInput.
			citationText.
			notesText}
]

{ #category : #'connection to model' }
SourceEditor >> model: aDrmSource [
	super model: aDrmSource.
	aDrmSource ifNil: [ ^ self ].
	self updateWidgetsFromModel
]

{ #category : #'connection to model' }
SourceEditor >> updateModel [
	self model
		notes:
			((notesText
				accept;
				text) ifNil: [ '' ]).
	self model class ~= DrmReference
		ifTrue: [ ^ self ].
	self model
		label:
			((labelTextInput
				accept;
				text) ifNil: [ '' ]).
	self model
		citation:
			((citationText
				accept;
				text) ifNil: [ '' ])
]

{ #category : #'connection to model' }
SourceEditor >> updateWidgetsFromModel [
	notesText text: self model notes.
	self model class ~= DrmReference
		ifTrue: [ ^ self ].
	labelTextInput text: self model label.
	citationText text: self model citation
]
