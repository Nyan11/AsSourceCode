Class {
	#name : #AsSourceCodeTest,
	#superclass : #TestCase,
	#category : #AsSourceCode
}

{ #category : #tests }
AsSourceCodeTest >> makeObjectFrom: aString [

	| doIt |
	doIt := thisContext compiler
		        source: aString;
		        isScripting: true;
		        compile.
	^ doIt valueWithReceiver: self arguments: #(  )
]

{ #category : #tests }
AsSourceCodeTest >> testArray [

	self assert: (self makeObjectFrom: {  } asSourceCode) class equals: Array.
	self assert: (self makeObjectFrom: {  } asSourceCode) size equals: 0.
	self assert: (self makeObjectFrom: { 1. 2. 3 } asSourceCode) class equals: Array.
	self assert: (self makeObjectFrom: { 1. 2. 3 } asSourceCode) size equals: 3.
	self assert: ((self makeObjectFrom: { 1. 2. 3 } asSourceCode) includes: 1).
	self assert: ((self makeObjectFrom: { 1. 2. 3 } asSourceCode) includes: 2).
	self assert: ((self makeObjectFrom: { 1. 2. 3 } asSourceCode) includes: 3).
]

{ #category : #tests }
AsSourceCodeTest >> testAssociation [

	self
		assert: (self makeObjectFrom: (1 -> 10) asSourceCode)
		equals: 1 -> 10.
	self
		assert: (self makeObjectFrom: (2 -> 20 -> 200) asSourceCode)
		equals: 2 -> 20 -> 200.
		
]

{ #category : #tests }
AsSourceCodeTest >> testBag [

	| object |
	object := self makeObjectFrom: { 1. 2. 3 } asBag asSourceCode.
	self assert: object class equals: Bag.
	self assert: object size equals: 3.
	self assert: (object includes: 1).
	self assert: (object includes: 2).
	self assert: (object includes: 3)
]

{ #category : #tests }
AsSourceCodeTest >> testComplexeObject [

	| oldObject newObject|
	oldObject := AsSourceCodeComplexeMock new.
	self assert: oldObject varA equals: nil.
	self assert: oldObject varB equals: nil.
	self assert: oldObject varC equals: nil.
	newObject := (self makeObjectFrom: oldObject asSourceCode).
	self assert: newObject class equals: AsSourceCodeComplexeMock.
	self assert: newObject varA equals: nil.
	self assert: newObject varB equals: nil.
	self assert: newObject varC equals: nil.
]

{ #category : #tests }
AsSourceCodeTest >> testComplexeObject2 [

	| oldObject newObject |
	oldObject := AsSourceCodeComplexeMock new.
	oldObject varA: 'test1'.
	oldObject varB: { 1. 2. 3 }.
	oldObject varC: AsSourceCodeMockObject1 new.
	self assert: oldObject varA equals: 'test1'.
	self assert: oldObject varB isCollection.
	self assert: (oldObject varB includes: 1).
	self assert: (oldObject varB includes: 2).
	self assert: (oldObject varB includes: 3).
	self assert: oldObject varC class equals: AsSourceCodeMockObject1.
	newObject := self makeObjectFrom: oldObject asSourceCode.
	self assert: newObject class equals: AsSourceCodeComplexeMock.
	self assert: newObject varA equals: 'test1'.
	self assert: newObject varB isCollection.
	self assert: (newObject varB includes: 1).
	self assert: (newObject varB includes: 2).
	self assert: (newObject varB includes: 3).
	self assert: newObject varC class equals: AsSourceCodeMockObject1
]

{ #category : #tests }
AsSourceCodeTest >> testComplexeObject3 [

	| oldObject newObject |
	oldObject := AsSourceCodeComplexeMock new.
	oldObject varA: 'test1'.
	oldObject varB: (AsSourceCodeComplexeMock new varA: 'test2'; yourself).
	self assert: oldObject varA equals: 'test1'.
	self assert: oldObject varB class equals: AsSourceCodeComplexeMock.
	self assert: oldObject varB varA equals: 'test2'.
	newObject := self makeObjectFrom: oldObject asSourceCode.
	self assert: newObject class equals: AsSourceCodeComplexeMock.
	self assert: newObject varA equals: 'test1'.
	self assert: newObject varB class equals: AsSourceCodeComplexeMock.
	self assert: newObject varB varA equals: 'test2'.
]

{ #category : #tests }
AsSourceCodeTest >> testDictionary [

	| object |
	object := self makeObjectFrom: { 10 -> 100. 20->200. 30->300 } asDictionary asSourceCode.
	self assert: object class equals: Dictionary.
	self assert: object size equals: 3.
	self assert: (object at: 10) equals: 100.
	self assert: (object at: 20) equals: 200.
	self assert: (object at: 30) equals: 300.
]

{ #category : #tests }
AsSourceCodeTest >> testLiteral [

	self assert: (self makeObjectFrom: 100 asSourceCode) equals: 100.
	self assert: (self makeObjectFrom: $a asSourceCode) equals: $a.
	self assert: (self makeObjectFrom: true asSourceCode) equals: true.
	self assert: (self makeObjectFrom: nil asSourceCode) equals: nil
]

{ #category : #tests }
AsSourceCodeTest >> testMakeObjectFrom [

	self assert: (self makeObjectFrom: '100') equals: 100.
	self assert: (self makeObjectFrom: 'nil') equals: nil.
	self assert: (self makeObjectFrom: '$a') equals: $a.
	self assert: (self makeObjectFrom: 'true') equals: true.
	self assert: (self makeObjectFrom: '''hello''') equals: 'hello'
]

{ #category : #tests }
AsSourceCodeTest >> testMultiReferences [

	| object arrayToTest newArrayToTest |
	object := AsSourceCodeSimpleMock new.
	arrayToTest := { object . object}.
	self assert: (arrayToTest at: 1) equals: object.
	self assert: (arrayToTest at: 1) equals: (arrayToTest at: 2).
	newArrayToTest := self makeObjectFrom: arrayToTest asSourceCode.
	self
		assert: (newArrayToTest at: 1) class
		equals: AsSourceCodeSimpleMock.
	self assert: (newArrayToTest at: 1) equals: (newArrayToTest at: 2)
]

{ #category : #tests }
AsSourceCodeTest >> testSet [

	| object |
	object := self makeObjectFrom: { 1. 2. 3 } asSet asSourceCode.
	self assert: object class equals: Set.
	self assert: object size equals: 3.
	self assert: (object includes: 1).
	self assert: (object includes: 2).
	self assert: (object includes: 3).
]

{ #category : #tests }
AsSourceCodeTest >> testSimpleClassObject [

	self
		assert: (self makeObjectFrom: AsSourceCodeSimpleMock asSourceCode)
		equals: AsSourceCodeSimpleMock
]

{ #category : #tests }
AsSourceCodeTest >> testSimpleObject [

	self
		assert: (self makeObjectFrom: AsSourceCodeSimpleMock new asSourceCode) class
		equals: AsSourceCodeSimpleMock
]

{ #category : #tests }
AsSourceCodeTest >> testString [

	self
		assert: (self makeObjectFrom: '' asSourceCode)
		equals: ''.
	self
		assert:
		(self makeObjectFrom: 'hello world' asSourceCode)
		equals: 'hello world'.
	self
		assert: (self makeObjectFrom: #symbol asSourceCode)
		equals: #symbol
]

{ #category : #tests }
AsSourceCodeTest >> testsOrderedCollection [

	| object |
	
	object := self makeObjectFrom:
		          { 1. 2. 3 } asOrderedCollection asSourceCode.
	self assert: object class equals: OrderedCollection.
	self assert: object size equals: 3.
	self assert: (object at: 1) equals: 1.
	self assert: (object at: 2) equals: 2.
	self assert: (object at: 3) equals: 3
]
