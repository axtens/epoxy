B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private Cursor As ResultSet
	
End Sub

Public Sub Initialize
	
End Sub

Sub Tag(mrk As String, txt As Object) As String
	Return "<" & mrk & ">" & txt & "</" & mrk & ">" 
End Sub

Sub Tag2(mrk As String, att As Map, txt As Object) As String
	Dim atts As String
	For Each k As String In att.Keys
		atts = atts & k & "='" & att.Get(k) & "' " 
	Next
	Return "<" & mrk & " " & atts & ">" & txt & "</" & mrk & ">" 
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	If req.FullRequestURI.EndsWith("/all") Then
		Cursor = Main.gSql.ExecQuery("SELECT * FROM Proxies ORDER BY  msec ASC, counter ")
	Else
		Cursor = Main.gSql.ExecQuery("SELECT * FROM Proxies WHERE inuse = 0 ORDER BY  msec ASC, counter ")
	End If

	Dim attribs As Map
	attribs.Initialize
	attribs.Put("style","border:1px solid black;")

	Dim rowAttribs As Map
	rowAttribs.Initialize
	
	Dim answer As String
	answer = ""
	Dim rowCount As Int = 1
	Do While Cursor.NextRow
		Dim msec As Int = Cursor.GetInt("msec")
		If msec >= 65536 Then
				rowAttribs.Put("style","background-color:red;")
		else if msec = 32768 Then
				rowAttribs.Put("style","background-color:yellow;")
			Else
				rowAttribs.Put("style","background-color:green;")
		End If
'		Select msec
'			Case 65536
'				rowAttribs.Put("style","background-color:red;")
'			Case 32768
'				rowAttribs.Put("style","background-color:yellow;")

'			Case Else
'				rowAttribs.Put("style","background-color:green;")
'		End Select
'
		answer = answer & Tag2("TR", rowAttribs, _
			Tag2("TD",attribs, rowCount ) & _
			Tag2("TD",attribs,Cursor.GetString("proxy")) & _
			Tag2("TD",attribs,Cursor.GetString("msec")) & _
			Tag2("TD",attribs,Cursor.GetString("counter")) & _
			Tag2("TD",attribs,Cursor.GetString("inuse")) & _
			Tag2("TD",attribs,Cursor.GetString("reason")))
			rowCount = rowCount + 1 
	Loop

	resp.Write(Tag2("TABLE",attribs,answer))

	LogDebug("LIST GENERATED")
	
End Sub