"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestVisualDrmer,
	#superclass : #PackageManifest,
	#category : #'VisualDrmer-Manifest'
}

{ #category : #'code-critics' }
ManifestVisualDrmer class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#DrmDiagramPresenter #drawSourcesLabelsOn: #false)) #'2021-01-06T15:21:03.498107-03:00') )
]

{ #category : #'code-critics' }
ManifestVisualDrmer class >> ruleRBStringConcatenationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#DrmDiagramPresenter #drawSourcesLabelsOn: #false)) #'2021-01-06T15:21:12.13794-03:00') )
]
