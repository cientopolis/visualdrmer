Class {
	#name : #DetailsEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'authorTextInput',
		'titleTextInput',
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
DetailsEditor >> initializePresenters [
	authorTextInput := self newTextInput.
	titleTextInput := self newTextInput.
	notesText := self newText.
	self focusOrder
		addAll:
			{authorTextInput.
			titleTextInput.
			notesText}
]
