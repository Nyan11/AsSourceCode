Extension { #name : #Object }

{ #category : #'*AsSourceCode' }
Object >> asSourceCode [

	| visitor |
	visitor := AsSourceCodeVisitor new.
	self asSourceCode: visitor.
	^ visitor sourceCode
]

{ #category : #'*AsSourceCode' }
Object >> asSourceCode: aSourceCodeVisitor [

	aSourceCodeVisitor addObjectReference: self
]

{ #category : #'*AsSourceCode' }
Object >> asSourceCodeConstructor [

	(self isLiteral and: [self isAssociation not]) ifTrue: [ ^ self printString ].
	^ self class name , ' new'
]

{ #category : #'*AsSourceCode' }
Object >> sourceCodeVariables [

	^ { }
]
