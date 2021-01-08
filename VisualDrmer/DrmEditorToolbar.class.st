Class {
	#name : #DrmEditorToolbar,
	#superclass : #SpPresenter,
	#instVars : [
		'toolBar'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmEditorToolbar class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar
			expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #initialization }
DrmEditorToolbar >> initializePresenters [
	toolBar := self newToolBar
		addItem:
			(SpToolBarButton new
				label: 'Save';
				icon: (self iconNamed: #save);
				help: 'Save';
				action: [ self inform: 'Save to file' ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Open';
				icon: (self iconNamed: #open);
				help: 'Open';
				action: [ self inform: 'Open a file' ];
				yourself);
		yourself
]
