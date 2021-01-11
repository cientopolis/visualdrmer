Class {
	#name : #FactorEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'attributeTextInput',
		'elementTextInput',
		'roleDropList'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
FactorEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: 'Attribute'
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #attributeTextInput
					expand: true
					fill: true
					padding: 0;
				yourself)
			expand: false;
		add:
			(SpBoxLayout newHorizontal
					add: 'Element'
						withConstraints: [ :constraints | constraints width: 80 ];
					add: #elementTextInput
						expand: true
						fill: true
						padding: 0;
					yourself)
			expand: false
			fill: false
			padding: 5;
		add:
			(SpBoxLayout newHorizontal
				add: 'Role'
					withConstraints: [ :constraints | constraints width: 80 ];
				add: #roleDropList;
				yourself)
			expand: false;
			yourself
]

{ #category : #constants }
FactorEditor class >> externalFactorLabel [
	^ 'External factor'
]

{ #category : #constants }
FactorEditor class >> keyFactorLabel [
	^ 'Key factor'
]

{ #category : #constants }
FactorEditor class >> measurableSuccessFactorLabel [
	^ 'Measurable success factor'
]

{ #category : #constants }
FactorEditor class >> normalFactorLabel [
	^ ''
]

{ #category : #examples }
FactorEditor class >> open [
	<example>
	^ self new openModalWithSpec
]

{ #category : #constants }
FactorEditor class >> successFactorLabel [
	^ 'Success factor'
]

{ #category : #initialization }
FactorEditor >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog
		initialExtent: 600 @ 160;
		title: 'Editing a factor';
		closeOnBackdropClick: false;
		okAction: [ :presenter | self updateModel ];
		cancelAction: [ :presenter | self model: nil ]
]

{ #category : #initialization }
FactorEditor >> initializePresenters [
	attributeTextInput := self newTextInput
		autoAccept: true;
		yourself.
	elementTextInput := self newTextInput
		autoAccept: true;
		yourself.
	roleDropList := self newDropList
		startWithoutSelection;
		items:
			{self class normalFactorLabel.
			self class keyFactorLabel.
			self class successFactorLabel.
			self class measurableSuccessFactorLabel.
			self class externalFactorLabel};
		yourself.
	self updateWidgetsFromModel.
	self focusOrder
		add: attributeTextInput;
		add: elementTextInput;
		add: roleDropList
]

{ #category : #callbacks }
FactorEditor >> updateModel [
	self model
		attribute:
			(attributeTextInput
				accept;
				text);
		element:
			(elementTextInput
				accept;
				text).
	roleDropList selectedItem = self class successFactorLabel
		ifTrue: [ self model beSuccessFactor ].
	roleDropList selectedItem = self class measurableSuccessFactorLabel
		ifTrue: [ self model beMeasurableSuccessFactor ].
	roleDropList selectedItem = self class keyFactorLabel
		ifTrue: [ self model beKeyFactor ].
	roleDropList selectedItem = self class externalFactorLabel
		ifTrue: [ self model beExternal ].
	roleDropList selectedItem isEmpty
		ifTrue: [ self model beNormal ]
]

{ #category : #initialization }
FactorEditor >> updateWidgetsFromModel [
	self model ifNil: [ ^ self ].
	attributeTextInput text: self model attribute.
	elementTextInput text: self model element.
	self model isNormal
		ifTrue: [ roleDropList selectItem: self class normalFactorLabel ].
	self model isExternal
		ifTrue: [ roleDropList selectItem: self class externalFactorLabel ].
	self model isKeyFactor
		ifTrue: [ roleDropList selectItem: self class keyFactorLabel ].
	self model isSuccessFactor
		ifTrue: [ roleDropList selectedItem: self class successFactorLabel ].
	self model isMeasurableSuccessFactor
		ifTrue: [ roleDropList selectedItem: self class measurableSuccessFactorLabel ]
]
