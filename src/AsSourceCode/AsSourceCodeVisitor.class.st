Class {
	#name : #AsSourceCodeVisitor,
	#superclass : #Object,
	#instVars : [
		'referencesDictionary',
		'uuid',
		'constructorsDictionary',
		'parametersDictionary',
		'arraysCollection',
		'specialsArraysCollection',
		'associationsCollection'
	],
	#category : #AsSourceCode
}

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> addArrayReference: anArray [

	(self isReferenced: anArray) ifTrue: [ ^ self ].
	self addNewReference: anArray.
	anArray do: [ :each | each asSourceCode: self ].
	self arraysCollection add: anArray
]

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> addAssociationReference: anAssociation [

	(self isReferenced: anAssociation) ifTrue: [ ^ self ].
	self addNewReference: anAssociation.
	anAssociation key asSourceCode: self.
	anAssociation value asSourceCode: self.
	self associationsCollection add: anAssociation
]

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> addCollectionReference: aCollection [

	| array |
	(self isReferenced: aCollection) ifTrue: [ ^ self ].
	array := aCollection asArray.
	self addNewReference: aCollection.
	array asSourceCode: self.
	self specialsArraysCollection at: aCollection put: array. 
]

{ #category : #adding }
AsSourceCodeVisitor >> addConstructorSourceCodeOf: anObject [

	self constructorsDictionary at: anObject put: anObject asSourceCodeConstructor
]

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> addDictionaryReference: aCollection [

	| array |
	(self isReferenced: aCollection) ifTrue: [ ^ self ].
	array := aCollection associations.
	self addNewReference: aCollection.
	array asSourceCode: self.
	self specialsArraysCollection at: aCollection put: array
]

{ #category : #adding }
AsSourceCodeVisitor >> addNewReference: anObject [

	| reference referenceUUID |
	referenceUUID := self nextUUID.
	reference := AsSourceCodeReference new.
	reference macro:
		('%<<1s>s>' expandMacrosWith: referenceUUID printString).
	reference variableName: ('_<1s>_<2s>'
			 expandMacrosWith: anObject class name \ ' '
			 with: referenceUUID printString).
	self referencesDictionary at: anObject put: reference
]

{ #category : #adding }
AsSourceCodeVisitor >> addObjectReference: anObject [

	(self isReferenced: anObject) ifTrue: [ ^ self ].
	self addNewReference: anObject.
	self addConstructorSourceCodeOf: anObject.
	self addParameterSourceCodeOf: anObject
]

{ #category : #adding }
AsSourceCodeVisitor >> addParameterSourceCodeOf: anObject [

	| parametersCollection |
	parametersCollection := OrderedCollection new.
	anObject sourceCodeVariables ifEmpty: [ ^ self ].
	anObject sourceCodeVariables do: [ :each |
		| propertyToSerialize |
		propertyToSerialize := anObject perform: each key.
		propertyToSerialize ifNotNil: [
			propertyToSerialize asSourceCode: self.
			parametersCollection add: (self
					 parameterStringFor: propertyToSerialize
					withSymbol: each value
					 on: anObject
					  ) ] ].

	self parametersDictionary at: anObject put: parametersCollection
]

{ #category : #accessing }
AsSourceCodeVisitor >> arraysCollection [

	^ arraysCollection
]

{ #category : #accessing }
AsSourceCodeVisitor >> associationsCollection [

	^ associationsCollection
]

{ #category : #accessing }
AsSourceCodeVisitor >> constructorsDictionary [

	^ constructorsDictionary
]

{ #category : #accessing }
AsSourceCodeVisitor >> initialize [

	associationsCollection := OrderedCollection new.
	arraysCollection := OrderedCollection new.
	specialsArraysCollection := OrderedDictionary new.
	referencesDictionary := OrderedDictionary new.
	constructorsDictionary := Dictionary new.
	parametersDictionary := Dictionary new.
	uuid := 0
]

{ #category : #adding }
AsSourceCodeVisitor >> isReferenced: anObject [

	^ self referencesDictionary includesKey: anObject
]

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> nextUUID [
	self uuid: self uuid + 1.
	^ self uuid
]

{ #category : #'as yet unclassified' }
AsSourceCodeVisitor >> parameterStringFor: aPropertyObject withSymbol: aSelector on: aTargetObject [

	self flag: #TODO. "aPropertyObject should define how a property is serialized."

	^ aSelector , ' '
	  , (self referencesDictionary at: aPropertyObject) macro
]

{ #category : #accessing }
AsSourceCodeVisitor >> parametersDictionary [

	^ parametersDictionary
]

{ #category : #accessing }
AsSourceCodeVisitor >> putReturnStatementOn: aStream [

	aStream
		                << self referencesDictionary values first macro
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeArrayConstructorsOn: aStream [

	self arraysCollection ifEmpty: [ ^ self ].
	aStream << '"Create all arrays (see Array class)."<r>'.
	self arraysCollection do: [ :array |
		aStream << (self referencesDictionary at: array) variableName
		<< ' := { '.
		array size > 1 ifTrue: [ aStream << '<r><t>' ].
		array
			do: [ :item |
				aStream << (self referencesDictionary at: item) variableName ]
			separatedBy: [ aStream << '.<r><t>' ].
		aStream << ' }.<r>' ].
	aStream << '<r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeAssociationConstructorsOn: aStream [

	self associationsCollection ifEmpty: [ ^ self ].
	aStream << '"Create all associations (see Association class)."<r>'.
	self associationsCollection do: [ :association |
		aStream << (self referencesDictionary at: association) variableName
		<< ' := ('.
		aStream
		<< (self referencesDictionary at: association key) variableName.
		aStream << ') -> ('.
		aStream
		<< (self referencesDictionary at: association value) variableName.
		aStream << ').<r>' ].
	aStream << '<r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeConstructorsOn: aStream [

	self constructorsDictionary ifEmpty: [ ^ self ].
	aStream
	<< '"Create all referenced object with their constructor string."<r>'.
	self referencesDictionary keysAndValuesDo: [ :object :reference |
		self constructorsDictionary
			at: object
			ifPresent: [ :constructorString |
				aStream << reference variableName << ' := ' << constructorString
				<< '.<r>' ] ].
	aStream << '<r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeParametersOn: aStream [

	self parametersDictionary ifEmpty: [ ^ self ].
	aStream << '"Call methods to change the variable of the objects."<r>'.
	self referencesDictionary keysAndValuesDo: [ :object :reference |
		self parametersDictionary at: object ifPresent: [ :parameters |
			parameters ifNotEmpty: [
				aStream << reference variableName << ' '.
				parameters
					do: [ :each | aStream << each ]
					separatedBy: [ aStream << ';<r><t>' ].
				aStream << '.<r>' ] ] ].
	aStream << '<r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeSpecialArrayConstructorsOn: aStream [

	self specialsArraysCollection ifEmpty: [ ^ self ].
	aStream
	<<
	'"Create all collection from the previous arrays (see Collection class)."<r>'.
	self specialsArraysCollection keysAndValuesDo: [ :collection :array |
		aStream << (self referencesDictionary at: collection) variableName.
		aStream << ' := '.
		aStream << collection class name << ' newFromArray: '
		<< (self referencesDictionary at: array) variableName.
		aStream << '.<r>' ].
	aStream << '<r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> putSourceCodeVariablesDeclarationOn: aStream [

	aStream << '| '.
	(self referencesDictionary values collect: [ :each |
		 each variableName ])
		do: [ :each | aStream << each ]
		separatedBy: [ aStream << ' ' ].
	aStream << ' |'.
	aStream << '<r><r>'
]

{ #category : #accessing }
AsSourceCodeVisitor >> referencesDictionary [

	^ referencesDictionary
]

{ #category : #accessing }
AsSourceCodeVisitor >> sourceCode [

	| sourceMacros |
	sourceMacros := String streamContents: [ :stream |
		                self putSourceCodeVariablesDeclarationOn: stream.
		                self putSourceCodeConstructorsOn: stream.
		                self putSourceCodeAssociationConstructorsOn: stream.
		                self putSourceCodeArrayConstructorsOn: stream.
		                self putSourceCodeSpecialArrayConstructorsOn: stream.
		                self putSourceCodeParametersOn: stream.
		                self putReturnStatementOn: stream.
		                 ].
	^ sourceMacros expandMacrosWithArguments:
		  (self referencesDictionary values collect: [ :each |
			   each variableName ])
]

{ #category : #accessing }
AsSourceCodeVisitor >> specialsArraysCollection [

	^ specialsArraysCollection
]

{ #category : #accessing }
AsSourceCodeVisitor >> uuid [

	^ uuid
]

{ #category : #accessing }
AsSourceCodeVisitor >> uuid: anObject [

	uuid := anObject
]
