B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Dim importList As List
End Sub

Public Sub Initialize
	importList.Initialize	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Main.gSql.ExecNonQuery("DELETE FROM Proxies")
	If req.Method = "GET" Then
		importList = File.ReadList(Main.proxiesTxt,"")
		For i = 0 To importList.Size - 1
			Main.gSql.ExecNonQuery2("INSERT OR REPLACE INTO Proxies VALUES (?,32768,0,0,?)", Array As Object(importList.Get(i),""))
		Next
	End If
	Dim answer As String
	answer = Main.gSql.ExecQuerySingleResult("SELECT COUNT(*) FROM Proxies")
	resp.Write(answer)
	LogDebug("IMPORTED FROM " & Main.proxiesTxt)
	
End Sub