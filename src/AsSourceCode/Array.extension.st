Extension { #name : #Array }

{ #category : #'*AsSourceCode' }
Array >> asSourceCode: aSourceCodeVisitor [

	aSourceCodeVisitor addArrayReference: self
]
