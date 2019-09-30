Type=Class
Version=4.2
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private Cursor As ResultSet
End Sub

Public Sub Initialize
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Dim jsonCount As Int = 0
	Cursor = Main.gSql.ExecQuery("SELECT * FROM Proxies WHERE efficacy < 7 ORDER BY msec ASC, efficacy DESC")
	Dim answer As String
	Dim leftOvers As String
	Dim final As String
	leftOvers = ""
	answer = ""
	final = ""

	Do While Cursor.NextRow
		If jsonCount > Main.jsonOffset Then
			answer = answer & QUOTE & Cursor.GetString("proxy") & QUOTE & ","
		Else
			leftOvers = leftOvers & QUOTE & Cursor.GetString("proxy") & QUOTE & ","
		End If
		jsonCount = jsonCount + 1
	Loop

	If leftOvers = "" Then
		final = answer.SubString2(0,answer.Length-1)
	Else
		final = answer & leftOvers.SubString2(0,leftOvers.Length-1) 
	End If

	resp.Write("[" & final & "]")
	Log("JSON GENERATED AFTER " & Main.jsonOffset)
	Main.jsonOffset = Main.jsonOffset + 1
End Sub