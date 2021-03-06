Class {
	#name : #MaixPyProxy,
	#superclass : #MicroPythonProxy,
	#category : #'MicroWiz-MPython'
}

{ #category : #api }
MaixPyProxy >> icon [
	^ ScratchTheme formAt: #maixpy
]

{ #category : #api }
MaixPyProxy >> newBlockSpecs [
	^ MaixPyBlockSpecs new
]

{ #category : #api }
MaixPyProxy >> newCode [
	^ MicroWizCode new
		generator: MicroPythonGenerator new;
		yourself
]
