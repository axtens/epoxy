B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.2
@EndOfDesignText@
'Handler class
Sub Class_Globals
	Private Cursor As ResultSet
	Private proxyList As List
End Sub

Public Sub Initialize
	proxyList.Initialize		
End Sub

Sub Handle(req As ServletRequest, resp As ServletResponse)
	Cursor = Main.gSql.ExecQuery("SELECT proxy FROM Proxies ORDER BY msec ASC")
	Do While Cursor.NextRow
		proxyList.Add(Cursor.GetString("proxy"))
	Loop
	File.WriteList(Main.proxiesTxt,"",proxyList)
	resp.Write(proxyList.Size)
	LogDebug("EXPORTED TO " & Main.proxiesTxt)
	
End Sub