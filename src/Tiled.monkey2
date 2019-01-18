Namespace tiledtools.tiled

#Import "<tinyxml2>"
#Import "<std>"

#Import "XMLTool"

Using tinyxml2
Using std.collections
Using std.geom
Using std.stringio
Using tiledtools.xml

Function LoadTileMap:XMLElement( location:String, printErrorCode:Bool = True )
	Local xml := LoadString( location )
	Local doc := New XMLDocument()
	Local err := doc.Parse(xml)
	If err<>XMLError.XML_SUCCESS 
		If printErrorCode Print "XML error: " + Int( err )
		Return Null
	End
	Return doc.LastChildElement()
End


' Provide it the xml root for a specific Tiled Object Layer
Function LayerLoadObjects:Stack<LayerObject>( layer:XMLElement )
	If layer.Name()<>"objectgroup" Return Null ' wrong type
	Local stack:= New Stack<LayerObject>
	
	For Local el:=Eachin XMLT.ChildElements( layer, "object" )
		stack.Push( New LayerObject( el ) )
	Next
	
	Return stack
End

Struct LayerObject
	Field el:XMLElement
	
	Method New( el_:XMLElement )
		el = el_	
	End
	
	' Basic Properties
	
	' the TMX-Specific type (not the user defined type)
	Property ObjectType:String()
		If el.NoChildren() Return ""
		Return el.FirstChildElement().Name()
	End
	
	Property Name:String()
		Return el.Attribute( "name" )
	End
	
	Property ID:Int()
		Return el.IntAttribute( "id" )
	End
	
	Property Type:String()
		Return el.Attribute( "type" )
	End
	
	Property X:Float()
		Return el.FloatAttribute( "x" )
	End
	
	Property Y:Float()
		Return el.FloatAttribute( "y" )
	End
	
	Property Width:Float()
		Return el.FloatAttribute( "width" )
	End
	
	Property Height:Float()
		Return el.FloatAttribute( "height" )
	End
	
	' IDENTIFIERS
	Property IsRectangle:Bool()
		Return el.NoChildren()
	End
	
	Property IsPoint:Bool()
		Return XMLT.HasChildElement( el, "point" )
	End
	
	Property IsEllipse:Bool()
		Return XMLT.HasChildElement( el, "ellipse" )
	End
	
	Property HasProperties:Bool()
		Return XMLT.HasChildElement( el, "properties" )
	End
	
	Property IsPolygon:Bool()
		Return XMLT.HasChildElement( el, "polygon" )
	End
	
	Property IsPolyline:Bool()
		Return XMLT.HasChildElement( el, "polyline" )
	End
	
	Property IsText:Bool()
		Return XMLT.HasChildElement( el, "image" )
	End
	
	' GETTERS
	
	Method GetPolyline:Stack<Vec2f>()
		Local line:=XMLT.FirstChildElement( el, "polyline" )
		Return ParsePointList<Float>( line.Attribute("points") )
	End
	
	Method GetPolygon:Stack<Vec2f>()
		Local poly:=XMLT.FirstChildElement( el, "polygon" )
		Return ParsePointList<Float>( poly.Attribute("points") )
	End
	
	Method GetVertices<T>:Stack<Vec2<T>>()
		Local poly:XMLElement
		If IsPolygon Then 
			poly=XMLT.FirstChildElement( el, "polygon" )
		Elseif IsPolyline Then 
			poly=XMLT.FirstChildElement( el, "polyline" )
		Else
			Return Null
		Endif
		Return ParsePointList<T>( poly.Attribute("points") )
	End
	
Private
	
	' Generates a stack of points from a tiled formatted string
	Function ParsePointList<T>:Stack<Vec2<T>>( data:String )
		Local points:= New Stack<Vec2<T>>
		Local index:=0
		Repeat	
			Local x:= data.Slice( index, data.Find( ",", index ) )
			index += x.Length + 1
			Local y:= data.Slice( index, data.Find( " ", index ) )
			index += y.Length + 1 
			points.Push( New Vec2f( Float(x), Float(y) ) )
		Until index>=data.Length
			
		Return points
	End
	
End


Private 
Alias XMLT:XMLTool 
