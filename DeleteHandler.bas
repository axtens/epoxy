Type=Class
Version=4.2
ModulesStructureVersion=1
B4J=true
@EndOfDesignText@
'Handler class
Sub Class_Globals
	
End Sub

Public Sub Initialize
	
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	dim ip as string = req.GetParameter("ip")
	If req.Method = "DELETE" Then
		Main.gSql.ExecNonQuery2("DELETE FROM Proxies WHERE proxy = ?", Array As Object(ip)) 'if not found, does nothing
		resp.Write("REMOVED " & ip)		
		Log("REMOVED " & ip)
	End If
End Sub