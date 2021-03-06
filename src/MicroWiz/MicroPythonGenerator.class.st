Class {
	#name : #MicroPythonGenerator,
	#superclass : #MicroWizGenerator,
	#instVars : [
		'newlineString',
		'imports',
		'modules',
		'varNo'
	],
	#category : #'MicroWiz-MPython'
}

{ #category : #'operators ops' }
MicroPythonGenerator >> abs: aNumber [
	^ self unaryFunction: 'abs' arg: aNumber
]

{ #category : #'operators ops' }
MicroPythonGenerator >> abs: aNumber1 sign: aNumber2 [
	^ self
		binaryFunction: self math , 'copysign'
		arg1: aNumber1
		arg2: aNumber2
]

{ #category : #private }
MicroPythonGenerator >> addExtModule: aString [
	extModules add: aString
]

{ #category : #'operators ops' }
MicroPythonGenerator >> and: x with: y [
	^ self binaryOperator: ' and ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> anyOf: anObject [
	^ self unaryFunction: self random, 'random_choice' arg: anObject
]

{ #category : #'list ops' }
MicroPythonGenerator >> append: arg toList: var [
	self
		appendWithNewline: (self getList: var) , (self unaryFunction: '.append' arg: arg)
]

{ #category : #private }
MicroPythonGenerator >> appendWithNewline: aString [
	self generateIndent: indent.
	super appendWithNewline: aString
]

{ #category : #private }
MicroPythonGenerator >> binaryFunction: aSymbol arg1: anObject1 arg2: anObject2 [
	| a b |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	^ aSymbol, '(', a, ',', b, ')'
]

{ #category : #private }
MicroPythonGenerator >> binaryOperator: aSymbol arg1: anObject1 arg2: anObject2 [
	| a b |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	^ '(' , a asString , aSymbol , b asString , ')'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> bytesFrom: str encoding: encoding [
	^ self binaryFunction: 'bytes' arg1: str arg2: encoding
]

{ #category : #'variable ops' }
MicroPythonGenerator >> changeVar: var by: val [
	self useVar: var.
	self appendWithNewline: var , ' = ' , var , ' + ' , (self valueOf: val)
]

{ #category : #'operators ops' }
MicroPythonGenerator >> computeFunction: aSymbol of: aNumber [
	| v f |
	v := self valueOf: aNumber.
	aSymbol = 'abs'
		ifTrue: [ ^ aSymbol , '(' , v , ')' ].
	aSymbol = '10 ^'
		ifTrue: [ ^ self math , 'pow(10,' , v , ')' ].
	f := aSymbol.
	f = 'log'
		ifTrue: [ f := 'log10' ].
	f = 'ln'
		ifTrue: [ f := 'log' ].
	f = 'e ^'
		ifTrue: [ f := 'exp' ].
	^ self math , f , '(' , v , ')'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> concatenate: x with: y [
	^ 'str(' , (self valueOf: x) , ')+str(' , (self valueOf: y) , ')'
]

{ #category : #'list ops' }
MicroPythonGenerator >> contentsOfList: var [
	^ self getList: var
]

{ #category : #'control ops' }
MicroPythonGenerator >> def: aString [
	self appendWithNewline: 'def ' , aString , '():'
]

{ #category : #'list ops' }
MicroPythonGenerator >> deleteLine: pos ofList: var [
	self
		appendWithNewline: 'del ' , (self getList: var) , '[' , (self listPosition: pos) , ']'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> divide: x by: y [
	^ self binaryOperator: ' / ' arg1: x arg2: y
]

{ #category : #'control ops' }
MicroPythonGenerator >> doForeverBegin [
	self appendWithNewline: 'while True:'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doForeverEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfBegin: cond [
	self appendWithNewline: 'if ' , (self valueOf: cond) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfElse [
	self appendWithNewline: 'else:'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIterateBegin: list var: var [
	self
		appendWithNewline: 'for ' , (self valueOf: var) , ' in ' , (self getList: list) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIterateEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doRepeatBegin: aNumber var: aString [
	self
		appendWithNewline: 'for ' , aString , ' in range(' , aNumber asString , '):'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doRepeatEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doUntilBegin: cond [
	self appendWithNewline: 'while not(' , (self valueOf: cond) , '):'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doUntilEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doWhileBegin: cond [
	self appendWithNewline: 'while ' , (self valueOf: cond) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doWhileEnd [
	"do nothing"
]

{ #category : #'operators ops' }
MicroPythonGenerator >> equal: x to: y [
	^ self binaryOperator: ' == ' arg1: x arg2: y
]

{ #category : #'modules ops' }
MicroPythonGenerator >> evaluate: func of: module [
	| f m |
	f := self valueOf: func.
	m := self valueOf: module.
	self import: m.
	(m isEmpty or: [ f isEmpty ])
		ifTrue: [ ^ '' ].
	^ m , '.' , f , '()'
]

{ #category : #'modules ops' }
MicroPythonGenerator >> execute: func of: module [
	| f m |
	f := self valueOf: func.
	m := self valueOf: module.
	self import: m.
	(m isEmpty or: [ f isEmpty ])
		ifTrue: [ ^ self ].
	self appendWithNewline: m , '.' , f , '()'
]

{ #category : #private }
MicroPythonGenerator >> falseString [
	^ self getFalse
]

{ #category : #private }
MicroPythonGenerator >> from: aSymbol1 import: aSymbol2 [ 
	| set |
	set := modules at: aSymbol1 ifAbsentPut: [Set new].
	set add: aSymbol2
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateExtCode: aSymbol arguments: aCollection for: aScript [
	| blockDef code |
	blockDef := aScript extBlockDefOf: aSymbol.
	code := blockDef codeWithArgs: aCollection.
	blockDef imports do: [ :each | self import: each ].
	blockDef isReporter
		ifTrue: [ ^ code ].
	code linesDo: [ :each | self appendWithNewline: each ].
	self addExtModule: blockDef moduleName
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateFrom: aString1 import: aString2 [
	self appendWithNewline: 'from ' , aString1 , ' import ' , aString2
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateGlobalVars: aCollection [
	| st |
	aCollection isEmpty
		ifTrue: [ ^ self ].
	st := WriteStream on: String new.
	st nextPutAll: 'global '.
	aCollection
		do: [ :each | st nextPutAll: each ]
		separatedBy: [ st nextPut: $, ].
	self appendWithNewline: st contents
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateHeader [
	self
		indent: 0;
		generateInitModules;
		generateInitVars;
		generateInitLists
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateImport: aString [
	self appendWithNewline: 'import ' , aString
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateIndent: anInteger [
	anInteger timesRepeat: [ stream nextPutAll: '    ' ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateInitLists [
	listVars do: [ :each | self appendWithNewline: each , '=[]' ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateInitModules [
	imports do: [ :each | self generateImport: each ].
	modules
		keysDo: [ :each | 
			(modules at: each)
				do: [ :each2 | self generateFrom: each import: each2 ] ].
	extModules
		do: [ :each | 
			(MicroWizProject availableModules at: each) header
				linesDo: [ :line | self appendWithNewline: line ] ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateInitVars [
	vars do: [ :each | self appendWithNewline: each , '=None' ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateIntCode: aSymbol arguments: aCollection for: aScript [
	| blockDef code |
	blockDef := aScript intBlockDefOf: aSymbol.
	code := blockDef codeWithArgs: aCollection.
	blockDef imports do: [ :each | self import: each ].
	blockDef isReporter
		ifTrue: [ ^ code ].
	code linesDo: [ :each | self appendWithNewline: each ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generatePass [
	self appendWithNewline: 'pass'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> getFalse [
	^ 'False'
]

{ #category : #'list ops' }
MicroPythonGenerator >> getLine: pos ofList: var [
	pos = #any
		ifTrue: [ ^ self random , 'choice(' , (self getList: var) , ')' ].
	^ (self getList: var) , '[' , (self listPosition: pos) , ']'
]

{ #category : #private }
MicroPythonGenerator >> getList: aList [
	self useListVar: aList.
	^ aList
]

{ #category : #'operators ops' }
MicroPythonGenerator >> getTrue [
	^ 'True'
]

{ #category : #private }
MicroPythonGenerator >> import: anObject [
	anObject isString
		ifTrue: [ imports add: anObject.
			^ self ].
	anObject isArray
		ifTrue: [ ^ self from: anObject first import: anObject second ].
	self error: 'invalid import'
]

{ #category : #private }
MicroPythonGenerator >> imports [
	^ imports
]

{ #category : #initialization }
MicroPythonGenerator >> initialize [
	super initialize.
	varNo := 0.
	imports := Set new.
	modules := Dictionary new.
	self newlineLF
]

{ #category : #'list ops' }
MicroPythonGenerator >> insert: val at: pos ofList: list [
	self
		appendWithNewline:
			(self getList: list) , '.insert(' , (self listPosition: pos) , ','
				, (self valueOf: val) , ')'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> is: x between: a and: b [
	^ '(' , (self valueOf: a) , ')<=(' , (self valueOf: x) , ')<=('
		, (self valueOf: b) , ')'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> isNone: anObject [
	^ (self valueOf: anObject) , ' is None'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> less: x than: y [
	^ self binaryOperator: ' < ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> letter: anInteger of: aString [
	| a b |
	a := self valueOf: anInteger.
	b := self valueOf: aString.
	^ '(', b, ')[', a, ']'
]

{ #category : #'list ops' }
MicroPythonGenerator >> lineCountOfList: var [
	^ 'len(' , (self getList: var) , ')'
]

{ #category : #'list ops' }
MicroPythonGenerator >> list: var contains: val [
	^ (self valueOf: val), ' in ', (self getList: var)
]

{ #category : #private }
MicroPythonGenerator >> listPosition: anObject [
	| v |
	v := self valueOf: anObject.
	v = '''all'''
		ifTrue: [ ^ ':' ].
	v = '''last'''
		ifTrue: [ ^ '-1' ].
	^ v
]

{ #category : #'code generator' }
MicroPythonGenerator >> literalStringFrom: anObject [ 
	((anObject isString)
		and: [anObject isNumberString not])
		ifTrue: [^ self quotedString: anObject].
	^ anObject asString
]

{ #category : #private }
MicroPythonGenerator >> localVarArgString: aString [
	^ aString
]

{ #category : #private }
MicroPythonGenerator >> math [
	self import: 'math'.
	^ 'math.'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> minus: x with: y [
	^ self binaryOperator: ' - ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> mod: x by: y [
	^ self binaryOperator: ' % ' arg1: x arg2: y
]

{ #category : #private }
MicroPythonGenerator >> modules [
	^ modules
]

{ #category : #'operators ops' }
MicroPythonGenerator >> more: x than: y [
	^ self binaryOperator: ' > ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> multiply: x and: y [
	^ self binaryOperator: ' * ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> negated: x [
	^ self minus: 0 with: x
]

{ #category : #private }
MicroPythonGenerator >> newVariable [
	varNo := varNo + 1.
	^ '_v', varNo asString
]

{ #category : #accessing }
MicroPythonGenerator >> newlineCR [
	newlineString := String cr
]

{ #category : #accessing }
MicroPythonGenerator >> newlineCRLF [
	newlineString := String crlf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineLF [
	newlineString := String lf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineString [
	^ newlineString
]

{ #category : #'operators ops' }
MicroPythonGenerator >> not: anObject [
	^ self unaryFunction: 'not' arg: anObject
]

{ #category : #private }
MicroPythonGenerator >> nullaryFunction: aSymbol [
	^ aSymbol, '()'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> numberOf: anObject [
	^ self unaryFunction: 'int' arg: anObject
]

{ #category : #'operators ops' }
MicroPythonGenerator >> or: x with: y [
	^ self binaryOperator: ' or ' arg1: x arg2: y
]

{ #category : #'operators ops' }
MicroPythonGenerator >> plus: x and: y [
	^ self binaryOperator: ' + ' arg1: x arg2: y
]

{ #category : #private }
MicroPythonGenerator >> quotedString: aString [ 
	| in out c |
	in := ReadStream on: aString.
	out := WriteStream on: String new.
	out nextPut: $'.
	[in atEnd]
		whileFalse: 
			[c := in next.
			('''' includes: c)
				ifTrue: [out nextPut: $\].
			out nextPut: c].
	out nextPut: $'.
	^ out contents
]

{ #category : #private }
MicroPythonGenerator >> random [
	self import: 'random'.
	^ 'random.'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> randomFrom: arg1 to: arg2 [
	^ self binaryFunction: self random, 'randint' arg1: arg1 arg2: arg2
]

{ #category : #'list ops' }
MicroPythonGenerator >> replaceAllList: var with: val [
	self
		appendWithNewline: (self getList: var) , ' = (' , (self valueOf: val) , ').split()'
]

{ #category : #'operators ops' }
MicroPythonGenerator >> rounded: aNumber [
	^ self unaryFunction: 'round' arg: aNumber
]

{ #category : #'list ops' }
MicroPythonGenerator >> setLine: pos ofList: var to: val [
	| p |
	p := pos = #any
		ifTrue: [ self random , 'randrange(len(' , (self getList: var) , '))' ]
		ifFalse: [ self listPosition: pos ].
	self
		appendWithNewline: (self getList: var) , '[' , p , '] = ' , (self valueOf: val)
]

{ #category : #'variable ops' }
MicroPythonGenerator >> setVar: var to: val [
	self useVar: var.
	self appendWithNewline: var , ' = ' , (self valueOf: val)
]

{ #category : #'operators ops' }
MicroPythonGenerator >> split: str by: delimiter limit: size to: list [
	self
		appendWithNewline:
			(self valueOf: list) , '=' , (self valueOf: str) , '.'
				, (self binaryFunction: 'split' arg1: delimiter arg2: size)
]

{ #category : #'code generator' }
MicroPythonGenerator >> stopThread [
	"do nothing"
]

{ #category : #'operators ops' }
MicroPythonGenerator >> stringFrom: str encoding: encoding [
	^ self binaryFunction: 'str' arg1: str arg2: encoding
]

{ #category : #'operators ops' }
MicroPythonGenerator >> stringLength: aString [
	^ self unaryFunction: 'len' arg: aString
]

{ #category : #'operators ops' }
MicroPythonGenerator >> stringOf: anObject [
	^ self unaryFunction: 'str' arg: anObject
]

{ #category : #private }
MicroPythonGenerator >> ternaryFunction: aSymbol arg1: anObject1 arg2: anObject2 arg3: anObject3 [
	| a b c |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	c := self valueOf: anObject3.
	^ aSymbol, '(', a, ',', b, ',', c, ')'
]

{ #category : #private }
MicroPythonGenerator >> unaryFunction: aString arg: anObject [
	| arg |
	arg := self valueOf: anObject.
	^ aString, '(', arg, ')'
]

{ #category : #private }
MicroPythonGenerator >> varNo [
	^ varNo
]

{ #category : #private }
MicroPythonGenerator >> variableArgString: aString [
	self useVar: aString.
	^ aString
]
