
#Import "assets/map.tmx"
#Import "<tiled-tools>"

Using tiledtools.tiled

Alias XMLT:tiledtools.xml.XMLTool

Function Main()
	
	Local tmap:=LoadTileMap( "asset::map.tmx" )
	
	' tmap.Parent().ToDocument().PrintDocument() ' Uncomment to compare results to tmx file
	
	
	' Go Through Each object group of the map
	For Local oGroup:=Eachin XMLT.ChildElements(tmap, "objectgroup")
		
		' Print the groups name
		Print "~n*** LAYER: ~q"+ oGroup.Attribute("name") +"~q *** ~n"
		
		
		' Load the objects
		For Local lobj:=Eachin LayerLoadObjects( oGroup )
'			Print "~ndefined name: " + lobj.Name
			Print "object type: " + ( lobj.ObjectType=""? "rect*" Else lobj.ObjectType  )
			
			Select True
				Case lobj.IsPolyline
					For Local point:=Eachin lobj.GetPolyline()
						Print "point: " + point
					Next
				Case lobj.IsPolygon
					For Local point:=Eachin lobj.GetPolygon()
						Print "point: " + point
					Next
			End
		Next	
	Next
	
End