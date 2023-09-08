Class {
	#name : #AsSourceCodeComplexeMock,
	#superclass : #Object,
	#instVars : [
		'varA',
		'varB',
		'varC'
	],
	#category : #AsSourceCode
}

{ #category : #'as yet unclassified' }
AsSourceCodeComplexeMock >> sourceCodeVariables [

	^ { #varA -> #varA: . #varB -> #varB: . #varC -> #varC: }
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varA [

	^ varA
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varA: anObject [

	varA := anObject
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varB [

	^ varB
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varB: anObject [

	varB := anObject
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varC [

	^ varC
]

{ #category : #accessing }
AsSourceCodeComplexeMock >> varC: anObject [

	varC := anObject
]
