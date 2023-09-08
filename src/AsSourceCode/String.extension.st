Extension { #name : #String }

{ #category : #'*AsSourceCode' }
String >> asSourceCode: aSourceCodeVisitor [

	aSourceCodeVisitor addObjectReference: self
]

{ #category : #'*AsSourceCode' }
String >> asSourceCodeConstructor [

	^ self printString
]
