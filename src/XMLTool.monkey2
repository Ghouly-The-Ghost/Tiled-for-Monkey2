Namespace tiledtools.xml

#Import "<std>"
#Import "<tinyxml2>"

Using tinyxml2..
Using std.collections..

' XML Helper

Struct XMLTool
	' checks if an element has a child of tag <tagName>
	Function HasChildElement:Bool( node:XMLNode, tagName:String )
		Return FirstChildElement( node, tagName )<>Null
	End
	
	' Finds the first of a child element of tag <tagName>
	Function FirstChildElement:XMLElement( node:XMLNode, tagName:String )
		If node.NoChildren() Return Null
		Local el:= node.FirstChildElement()
		Return el.Name()=tagName? el Else NextSiblingElement( el, tagName )
	End
	
	' Returns a stack of elements with tag <tagName>
	Function ChildElements:Stack<XMLElement>( node:XMLNode, tagName:String )
		If node.NoChildren() Return Null
		
		Local childStack:= New Stack<XMLElement>
		Local el:= node.FirstChildElement()
		Repeat
			If el.Name()=tagName childStack.Push( el )
			el = el.NextSiblingElement()
		Until el=Null
		
		Return childStack
	End
	
	' Checks if element has siblign of tag <tagName>
	Function HasSiblingElement:Bool( el:XMLElement, tagName:String )
		Return NextSiblingElement( el, tagName )<>Null
	End
	
	' Finds next sibling of tag <tagName>
	Function NextSiblingElement:XMLElement( el:XMLElement, tagName:String )
		el = el.NextSiblingElement()
		While el<>Null
			If el.Name()=tagName Return el
			el = el.NextSiblingElement()
		Wend
		
		Return Null
	End
	
End
