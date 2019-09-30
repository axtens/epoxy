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
	Dim ip As String = req.GetParameter("ip")
	If req.Method = "DELETE" Then
		Main.gSql.ExecNonQuery2("DELETE FROM Proxies WHERE proxy = ?", Array As Object(ip)) 'if not found, does nothing
		resp.Write("REMOVED " & ip)		
		LogDebug("REMOVED " & ip)
	End If
End Sub