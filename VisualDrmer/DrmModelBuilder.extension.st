Extension { #name : #DrmModelBuilder }

{ #category : #'*VisualDrmer' }
DrmModelBuilder class >> figureTp [
	| builder costOfProduction amountOfProfit timeToMarket link qualityOfProduct customerSatisfaction qualityOfProblemDefinition supportProblemDefinition qualityOfdesing numberOfmodi porcentaje source assumption sourceB |
	builder := self new.
	source := builder
		referenceLabeled: '5'
		citation: 'Gomez A. El libro de los sueños (1996).'.
	sourceB := builder
		referenceLabeled: '5b'
		citation: 'Gomez A. El libro de los sueños II parte (1998).'.
	assumption := builder assumption: 'Because I say so'.
	costOfProduction := builder
		factorOnAttribute: 'cost'
		of: 'production'.
	costOfProduction isExternal: true.
	amountOfProfit := builder factorOnAttribute: 'amount' of: 'profit'.
	builder link: costOfProduction to: amountOfProfit.
	timeToMarket := builder
		factorOnAttribute: 'duration'
		of: 'time-to-market'.
	link := builder link: timeToMarket to: amountOfProfit.
	assumption := builder assumption: ''.
	link
		levelAtOrigin: '-';
		levelAtDestination: '+';
		addSource: assumption.
	qualityOfProduct := builder
		factorOnAttribute: 'quality'
		of: 'product'.
	customerSatisfaction := builder
		factorOnAttribute: 'satisfaction'
		of: 'customer '.
	link := builder link: qualityOfProduct to: customerSatisfaction.
	link
		levelAtOrigin: '+';
		levelAtDestination: '+';
		addSource: source;
		addSource: sourceB.
	link := builder link: qualityOfProduct to: amountOfProfit.
	link
		levelAtOrigin: '+';
		levelAtDestination: '+';
		addSource: assumption.
	qualityOfProblemDefinition := builder
		factorOnAttribute: 'quality'
		of: 'problem definition'.
	supportProblemDefinition := builder
		support: 'support problem definition'.
	link := builder
		link: supportProblemDefinition
		to: qualityOfProblemDefinition.
	link
		levelAtDestination: '+';
		addSource: assumption.
	qualityOfdesing := builder
		factorOnAttribute: 'quality'
		of: 'design evaluation'.
	link := builder link: qualityOfProblemDefinition to: qualityOfdesing.
	link
		levelAtOrigin: '+';
		levelAtDestination: '-';
		addSource: assumption.
	link := builder link: qualityOfdesing to: qualityOfProduct.
	link
		levelAtOrigin: '+';
		levelAtDestination: '+';
		addSource: assumption.
	numberOfmodi := builder
		factorOnAttribute: 'number'
		of: 'modifications'.
	link := builder link: qualityOfProblemDefinition to: numberOfmodi.
	link
		levelAtOrigin: '+';
		levelAtDestination: '-';
		addSource: assumption.
	porcentaje := builder
		factorOnAttribute: '%'
		of: 'design time spent on modifications'.
	link := builder link: qualityOfProblemDefinition to: porcentaje.
	link
		levelAtOrigin: '+';
		levelAtDestination: '-';
		addSource: assumption.
	link := builder link: porcentaje to: timeToMarket.
	link
		levelAtOrigin: '-';
		levelAtDestination: '-';
		addSource: assumption.
	link := builder link: numberOfmodi to: porcentaje.
	link
		levelAtOrigin: '-';
		levelAtDestination: '-';
		addSource: assumption.
	^ builder model
]
