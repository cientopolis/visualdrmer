Class {
	#name : #DrmSourcesEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'sourcesList'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmSourcesEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: 'Sources' expand: false;
		add: #sourcesList;
		yourself
]

{ #category : #specs }
DrmSourcesEditor class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #initialization }
DrmSourcesEditor >> initializePresenters [ 
	sourcesList := self newList.
	
]

{ #category : #initialization }
DrmSourcesEditor >> initializeWindow: window [
	window
		initialExtent: 1200 @ 750
]
