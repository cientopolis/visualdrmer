Class {
	#name : #DrmEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'fileReference',
		'tabManager',
		'diagramPresenter',
		'fileToolBar',
		'layoutToolBar',
		'editToolBar'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBarPresenter expand: false;
		add: #tabManager;
		yourself
]

{ #category : #examples }
DrmEditor class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: 'DRM editor') action: [ self new openWithSpec ]
]

{ #category : #examples }
DrmEditor class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
DrmEditor class >> title [
	^ 'Dremer'
]

{ #category : #'private callbacks' }
DrmEditor >> addLink [
	UIManager default alert: 'Not yet implemented'
]

{ #category : #'private callbacks' }
DrmEditor >> addNode [
	| editor |
	editor := FactorEditor new
		model: DrmFactor new;
		yourself.
	editor openModalWithSpec.
   editor model ifNotNil: [ :newNode | model addNode: newNode ] 
]

{ #category : #'private callbacks' }
DrmEditor >> autoLayout [
	diagramPresenter autoLayout
]

{ #category : #initialization }
DrmEditor >> buildToolBar [
	^ self newToolBar
		addItem:
			(SpToolBarButton new
				label: 'New';
				icon: (self iconNamed: #changeAdd);
				help: 'Create an empty model';
				action: [ self newModel ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Open';
				icon: (self iconNamed: #open);
				help: 'Open';
				action: [ self inform: 'Open a file' ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Save';
				icon: (self iconNamed: #smallSave);
				help: 'Save';
				action: [ self save ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Save as';
				icon: (self iconNamed: #smallSaveAs);
				help: 'Save as';
				action: [ self saveAs ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Fit';
				icon: (self iconNamed: #smallWindow);
				help: 'Zoom to fit';
				action: [ self zoomToFit ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Layout';
				icon: (self iconNamed: #references);
				help: 'Automatic layout';
				action: [ self autoLayout ];
				yourself);
		yourself
]

{ #category : #initialization }
DrmEditor >> connectPresenters [
	diagramPresenter
		addNodeBlock: [ self addNode ];
		editNodeBlock: [ :node | self editNode: node ];
		removeNodeBlock: [ :node | self removeNode: node ];
		addLinkBlock: [ self addLink ];
		editLinkBindingsBlock: [ :link | self editLinkBindings: link ];
		editLinkSourcesBlock: [ :link | self editLinkSources: link ];
		removeLinkBlock: [ :link | self removeLink: link ]
]

{ #category : #initialization }
DrmEditor >> detailsTab [
	^ SpNotebookPage
		title: 'Details'
		icon: (self iconNamed: #glamorousBrowse)
		provider: [ self newText
				text: 'Formulario';
				yourself ]
]

{ #category : #initialization }
DrmEditor >> diagramTab [
	^ SpNotebookPage
		title: 'Diagram'
		icon: (self iconNamed: #objects)
		provider: [ diagramPresenter
				model: model;
				yourself ]
]

{ #category : #'private callbacks' }
DrmEditor >> editLinkBindings: aDrmLink [
	| editor |
	editor := LinkBindingsEditor new
		availableNodes: model nodes;
		model: aDrmLink;
		yourself.
	editor openModalWithSpec
]

{ #category : #'private callbacks' }
DrmEditor >> editLinkSources: aDrmLink [
	UIManager default alert: 'Not yet implemented'
]

{ #category : #'private callbacks' }
DrmEditor >> editNode: aNode [
	| editor |
	editor := FactorEditor new
		model: aNode;
		yourself.
	editor openModalWithSpec
]

{ #category : #initialization }
DrmEditor >> initialize [
	super initialize.
	model := DrmModelBuilder figureTwoDotSix.

]

{ #category : #initialization }
DrmEditor >> initializePresenters [
	tabManager := self newNotebook.
	toolBarPresenter := self buildToolBar.  
	diagramPresenter := DrmDiagramPresenter new.
	tabManager
		addPage: self diagramTab;
		addPage: self detailsTab
]

{ #category : #initialization }
DrmEditor >> initializeWindow: window [
	window
		initialExtent: 1200 @ 750
]

{ #category : #accessing }
DrmEditor >> model: aDrmModel [
	model := aDrmModel.
	diagramPresenter model: aDrmModel
]

{ #category : #'private callbacks' }
DrmEditor >> newModel [
	self model: DrmModel new.
	fileReference := nil.
]

{ #category : #'private callbacks' }
DrmEditor >> open [
	fileReference := UIManager default
		chooseExistingFileReference: 'Which file?'
		extensions: #('drm')
		path: FileLocator home.
	fileReference ifNil: [ ^ self ].
	self
		model: (FLMaterializer materializeFromFileNamed: fileReference fullName).
	self zoomToFit
]

{ #category : #'private callbacks' }
DrmEditor >> removeLink: aLink [
	(UIManager default
		confirm:
			'Are you sure you want to remove this link? This action cannot be undone.')
		ifFalse: [ ^ self ].
	model removeLink: aLink
]

{ #category : #'private callbacks' }
DrmEditor >> removeNode: aNode [
	(UIManager default
		confirm: 'Are you sure you want to remove this node? This action cannot be undone.')
		ifFalse: [ ^ self ].
	model removeNode: aNode
]

{ #category : #private }
DrmEditor >> roassalWidget [
	^ DrmDiagramPresenter new
		model: model;
		createMorph
]

{ #category : #'private callbacks' }
DrmEditor >> save [
	fileReference ifNil: [ ^ self saveAs ].
	self saveWithoutChecking
]

{ #category : #'private callbacks' }
DrmEditor >> saveAs [
	fileReference := UIManager default
		chooseForSaveFileReference: 'Save model as?'
		extensions: #('drm')
		path: model title asFileName , '.drm'.
	fileReference ifNil: [ ^ self ].
	fileReference exists
		ifTrue: [ (self confirm: 'File exists, overwrite?')
				ifFalse: [ ^ self ] ].
	self saveWithoutChecking
]

{ #category : #'private callbacks' }
DrmEditor >> saveWithoutChecking [
	FLSerializer serialize: model toFileNamed: fileReference fullName.
	self inform: 'Model saved as ' , fileReference fullName
]

{ #category : #accessing }
DrmEditor >> tabManager [
	^ tabManager
]

{ #category : #accessing }
DrmEditor >> tabManager: anObject [
	tabManager := anObject
]

{ #category : #updating }
DrmEditor >> updateModel [
	self .
]

{ #category : #'private callbacks' }
DrmEditor >> zoomToFit [ 	
	diagramPresenter zoomToFit 
]
