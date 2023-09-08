Extension { #name : #Association }

{ #category : #'*AsSourceCode' }
Association >> asSourceCode: aSourceCodeVisitor [

	aSourceCodeVisitor addAssociationReference: self
]
