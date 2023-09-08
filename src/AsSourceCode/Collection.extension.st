Extension { #name : #Collection }

{ #category : #'*AsSourceCode' }
Collection >> asSourceCode: aSourceCodeVisitor [

	aSourceCodeVisitor addCollectionReference: self
]

{ #category : #'*AsSourceCode' }
Collection >> asSourceCodeConstructor [

	^ self class name , ' newFromArray: ' , self asArray asSourceCode
]
