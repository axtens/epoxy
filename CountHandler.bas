﻿B4J=true
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
	Dim count As Object =Main.gSql.ExecQuerySingleResult("SELECT COUNT(*) FROM Proxies")
	resp.Write(count)	
 	LogDebug("COUNT " & count)
End Sub