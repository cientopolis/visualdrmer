Class {
	#name : #DrmEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'fileReference',
		'tabManager',
		'diagramPresenter',
		'sourcesPresenter',
		'fileToolBar',
		'layoutToolBar',
		'editToolBar'
	],
	#category : #'VisualDrmer-SpecUI'
}

{ #category : #specs }
DrmEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: #fileToolBar expand: false;
				add: (Smalltalk ui icons iconNamed: #blank) expand: false;
				add: #layoutToolBar expand: false;
				add: (Smalltalk ui icons iconNamed: #blank) copy expand: false;
				add: #editToolBar expand: false;
				yourself)
			expand: false;
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
DrmEditor >> addFactor [
	| editor |
	editor := FactorEditor new
		model: DrmFactor new;
		yourself.
	editor openModalWithSpec.
   editor model ifNotNil: [ :newNode | model addNode: newNode ] 
]

{ #category : #'private callbacks' }
DrmEditor >> addLink [
	| editor |
	editor := LinkEditor new
		model: DrmLink new;
		drmModel: model.
	editor openModalWithSpec.
	editor model ifNotNil: [ :newLink | model addLink: newLink ]
]

{ #category : #'private callbacks' }
DrmEditor >> autoLayout [
	diagramPresenter autoLayout
]

{ #category : #private }
DrmEditor >> buildEditToolBar [
	^ self newToolBar
		addItem:
			(SpToolBarButton new
				label: 'Factor';
				icon: (self iconNamed: #uncommentedClass);
				help: 'Add a new factor';
				action: [ self addFactor ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Support';
				icon: (self iconNamed: #smallWindow);
				help: 'Add a new support';
				action: [ self inform: 'Support added' ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Link';
				icon: (self iconNamed: #references);
				help: 'Add a new link';
				action: [ self addLink ];
				yourself);
		yourself
]

{ #category : #private }
DrmEditor >> buildFileToolBar [
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
				label: 'Example';
				icon: (self iconNamed: #image);
				help: 'Opens an example model';
				action: [ self openExample ];
				yourself);

		addItem:
			(SpToolBarButton new
				label: 'Open';
				icon: (self iconNamed: #open);
				help: 'Open';
				action: [ self open ];
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
		yourself
]

{ #category : #private }
DrmEditor >> buildLayoutToolBar [
	^ self newToolBar
		addItem:
			(SpToolBarButton new
				label: 'Fit';
				icon: (self iconNamed: #glamorousZoomToFit );
				help: 'Zoom to fit';
				action: [ self zoomToFit ];
				yourself);
		addItem:
			(SpToolBarButton new
				label: 'Layout';
				icon: (self iconNamed: #hierarchy );
				help: 'Automatic layout';
				action: [ self autoLayout ];
				yourself);
		yourself
]

{ #category : #initialization }
DrmEditor >> connectPresenters [
	diagramPresenter
		addNodeBlock: [ self addFactor ];
		editNodeBlock: [ :node | self editNode: node ];
		removeNodeBlock: [ :node | self removeNode: node ];
		addLinkBlock: [ self addLink ];
		editLinkBlock: [ :link | self editLink: link ];
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
		provider: [ diagramPresenter ]
]

{ #category : #'private callbacks' }
DrmEditor >> editLink: aDrmLink [
	| editor |
	editor := LinkEditor new
		drmModel: model;
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
	model := DrmModel new.
	super initialize
]

{ #category : #initialization }
DrmEditor >> initializePresenters [
	fileToolBar := self buildFileToolBar.
	layoutToolBar := self buildLayoutToolBar.
	editToolBar := self buildEditToolBar.
	diagramPresenter := DrmDiagramPresenter new
		model: model;
		yourself.
	sourcesPresenter := SourcesPresenter new
		model: model;
		yourself.
	tabManager := self newNotebook
		addPage: self diagramTab;
		addPage: self detailsTab;
		addPage: self sourcesTab;
		yourself
]

{ #category : #initialization }
DrmEditor >> initializeWindow: window [
	window
		initialExtent: 1200 @ 750
]

{ #category : #accessing }
DrmEditor >> model: aDrmModel [
	model := aDrmModel.
	diagramPresenter model: aDrmModel.
	sourcesPresenter model: aDrmModel
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
DrmEditor >> openExample [
	self model: DrmModelBuilder figureTp.
	self autoLayout
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

{ #category : #initialization }
DrmEditor >> sourcesTab [
	^ SpNotebookPage
		title: 'Sources'
		icon: (self iconNamed: #recentMessages)
		provider: [ sourcesPresenter ]
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
