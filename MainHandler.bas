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
	Dim ip As String
	ip = req.GetParameter("ip")
	Dim sMsec As String
	sMsec = req.GetParameter("msec")
	Dim answer As String
		
	Select req.Method 
		Case "POST" ' Create
			Main.gSql.ExecNonQuery2("INSERT OR REPLACE INTO Proxies VALUES (?, 32768, 0, 0, '')",Array As Object(ip))
			resp.Write("OK")
			LogDebug("CREATED " & ip)
			
		Case "GET" ' Retrieve
			answer = Main.gSql.ExecQuerySingleResult("SELECT proxy FROM Proxies WHERE inuse = 0 AND counter < 7 ORDER BY msec ASC LIMIT 1")
			If answer = Null Then
				LogDebug("RETRY")
				resp.Write("RETRY")
			Else
				Main.gSql.ExecNonQuery2("UPDATE Proxies SET inuse = 1, counter = 1 WHERE proxy = ?", Array As Object(answer))
				resp.Write(answer)
				LogDebug("RETRIEVED " & answer)
			End If	
			
		Case "PUT" ' Update
		    Dim iMsec As Int = sMsec	
			Main.gSql.ExecNonQuery2("UPDATE Proxies SET inuse = 0, counter = counter + 1, msec = ? WHERE proxy = ?", Array As Object(iMsec, ip))
			LogDebug("UPDATED " & ip)
		
		Case "DELETE" ' Delete
			Dim currMsec As Int
			currMsec = Main.gSql.ExecQuerySingleResult2("SELECT msec FROM Proxies WHERE proxy = ?", Array As Object(ip))
			currMsec = currMsec + 1
			If currMsec < 65536 Then
				currMsec = currMsec + 32768
			End If
			Main.gSql.ExecNonQuery2("UPDATE Proxies SET inuse = 0, counter = 0, msec = ? WHERE proxy = ?", Array As Object(currMsec, ip)) 'if not found, does nothing
			resp.Write("DEPRECATED " & ip)		
			LogDebug("DEPRECATED " & ip)
			
		Case Else
			resp.Write("FAiL")
	End Select
	
End Sub

Sub Delay (DurationMs As Int)
 Dim target As Long
 Dim slice As Long = DurationMs / 10
 For i = 1 To 10
	 target = DateTime.Now + slice
	 Do While DateTime.Now < target
	 Loop
Next
End Sub
