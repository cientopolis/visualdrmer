Class {
	#name : #FactorEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'attributeTextInput',
		'elementTextInput',
		'isExternalCheckbox'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
FactorEditor class >> defaultSpec [
	^ SpGridLayout new
	   beRowHomogeneous ;
		add: 'Attribute' at: 1 @ 1;
		add: #attributeTextInput at: 2 @ 1;
		add: 'Element' at: 1 @ 2;
		add: #elementTextInput at: 2 @ 2;
		add: 'Is external' at: 1 @ 3;
		add: #isExternalCheckbox at: 2 @ 3;
		yourself
]

{ #category : #examples }
FactorEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #examples }
FactorEditor class >> title [
	^ 'Editing a node'
]

{ #category : #initialization }
FactorEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		closeOnBackdropClick: true;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
FactorEditor >> initializePresenters [
	attributeTextInput := self newTextInput
		autoAccept;
		yourself.
	elementTextInput := self newTextInput
		autoAccept;
		yourself.
	isExternalCheckbox := self newCheckBox.

]

{ #category : #callbacks }
FactorEditor >> updateModel [
	self model
		attribute: attributeTextInput text;
		element: elementTextInput text;
		isExternal: isExternalCheckbox state
]

{ #category : #initialization }
FactorEditor >> updateWidgetsFromModel [
	attributeTextInput text: self model attribute.
	elementTextInput text: self model element.
	isExternalCheckbox state: self model isExternal
]