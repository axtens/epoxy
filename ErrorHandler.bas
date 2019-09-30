B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Handler class
Sub Class_Globals
	
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	If req.Method = "PUT" Then
		Dim ip As String = req.GetParameter("ip")
		Dim reason As String = req.GetParameter("reason")
		Main.gSql.ExecNonQuery2("UPDATE Proxies SET reason = ? WHERE proxy = ?", Array As Object(reason, ip))
		LogDebug("REASON NOTED")
	End If
End Sub