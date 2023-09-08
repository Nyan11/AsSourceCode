Class {
	#name : #AsSourceCodeReference,
	#superclass : #Object,
	#instVars : [
		'macro',
		'variableName'
	],
	#category : #AsSourceCode
}

{ #category : #accessing }
AsSourceCodeReference >> macro [

	^ macro
]

{ #category : #accessing }
AsSourceCodeReference >> macro: anObject [

	macro := anObject
]

{ #category : #accessing }
AsSourceCodeReference >> variableName [

	^ variableName
]

{ #category : #accessing }
AsSourceCodeReference >> variableName: anObject [

	variableName := anObject
]
