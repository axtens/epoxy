B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=4.2
@EndOfDesignText@
' Code module
' Version 1.10
Sub Process_Globals
	Public DB_REAL, DB_INTEGER, DB_BLOB, DB_TEXT As String
	DB_REAL = "REAL"
	DB_INTEGER = "INTEGER"
	DB_BLOB = "BLOB"
	DB_TEXT = "TEXT"
End Sub


'Creates a new table with the given name.
'FieldsAndTypes - A map with the fields names as keys and the types as values.
'You can use the DB_... constants for the types.
'PrimaryKey - The column that will be the primary key. Pass empty string if not needed.
Public Sub CreateTable(SQL As SQL, TableName As String, FieldsAndTypes As Map, PrimaryKey As String)
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("(")
	For i = 0 To FieldsAndTypes.Size - 1
		Dim field, ftype As String
		field = FieldsAndTypes.GetKeyAt(i)
		ftype = FieldsAndTypes.GetValueAt(i)
		If i > 0 Then sb.Append(", ")
		sb.Append("[").Append(field).Append("] ").Append(ftype)
		If field = PrimaryKey Then sb.Append(" PRIMARY KEY")
	Next
	sb.Append(")")
	Dim query As String
	query = "CREATE TABLE IF NOT EXISTS [" & TableName & "] " & sb.ToString
	LogDebug("CreateTable: " & query)
	SQL.ExecNonQuery(query)
End Sub

'Deletes the given table.
Public Sub DropTable(SQL As SQL, TableName As String)
	Dim query As String
	query = "DROP TABLE IF EXISTS [" & TableName & "]"
	LogDebug("DropTable: " & query)
	SQL.ExecNonQuery(query)
End Sub


' updates a single field in a record
' Field is the column name
Public Sub UpdateRecord(SQL As SQL, TableName As String, Field As String, NewValue As Object, _
	WhereFieldEquals As Map)
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("UPDATE [").Append(TableName).Append("] SET [").Append(Field).Append("] = ? WHERE ")
	If WhereFieldEquals.Size = 0 Then
		LogDebug("WhereFieldEquals map empty!")
		Return
	End If
	Dim args As List
	args.Initialize
	args.Add(NewValue)
	For i = 0 To WhereFieldEquals.Size - 1
		If i > 0 Then sb.Append(" AND ")
		sb.Append("[").Append(WhereFieldEquals.GetKeyAt(i)).Append("] = ?")
		args.Add(WhereFieldEquals.GetValueAt(i))
	Next
	LogDebug("UpdateRecord: " & sb.ToString)
	SQL.ExecNonQuery2(sb.ToString, args)
End Sub

' updates multiple fields in a record
' in the Fields map the keys are the column names
Public Sub UpdateRecord2(SQL As SQL, TableName As String, Fields As Map, WhereFieldEquals As Map)
	If WhereFieldEquals.Size = 0 Then
		LogDebug("WhereFieldEquals map empty!")
		Return
	End If
	If Fields.Size = 0 Then
		LogDebug("Fields empty")
		Return
	End If
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("UPDATE [").Append(TableName).Append("] SET ")
	Dim args As List
	args.Initialize
	For i=0 To Fields.Size-1
		If i<>Fields.Size-1 Then
			sb.Append("[").Append(Fields.GetKeyAt(i)).Append("]=?,")
		Else
			sb.Append("[").Append(Fields.GetKeyAt(i)).Append("]=?")
		End If
		args.Add(Fields.GetValueAt(i))
	Next
    
	sb.Append(" WHERE ")
	For i = 0 To WhereFieldEquals.Size - 1
		If i > 0 Then 
			sb.Append(" AND ")
		End If
		sb.Append("[").Append(WhereFieldEquals.GetKeyAt(i)).Append("] = ?")
		args.Add(WhereFieldEquals.GetValueAt(i))
	Next
	LogDebug("UpdateRecord: " & sb.ToString)
	SQL.ExecNonQuery2(sb.ToString, args)
End Sub


'Gets the current version of the database. If the DBVersion table does not exist it is created and the current
'version is set to version 1.
Public Sub GetDBVersion (SQL As SQL) As Int
	Dim count, version As Int
	count = SQL.ExecQuerySingleResult("SELECT count(*) FROM sqlite_master WHERE Type='table' AND name='DBVersion'")
	If count > 0 Then
		version = SQL.ExecQuerySingleResult("SELECT version FROM DBVersion")
	Else
		'Create the versions table.
		Dim m As Map
		m.Initialize
		m.Put("version", DB_INTEGER)
		CreateTable(SQL, "DBVersion", m, "version")
		
		SQL.ExecNonQuery("INSERT INTO DBVersion VALUES (1)")
		
		version = 1
	End If
	
	Return version
End Sub

'Sets the database version to the given version number.
Public Sub SetDBVersion (SQL As SQL, Version As Int)
	SQL.ExecNonQuery2("UPDATE DBVersion set version = ?", Array As Object(Version))
End Sub

' deletes a record
Public Sub DeleteRecord(SQL As SQL, TableName As String, WhereFieldEquals As Map)
    Dim sb As StringBuilder
    sb.Initialize
    sb.Append("DELETE FROM [").Append(TableName).Append("] WHERE ")
    If WhereFieldEquals.Size = 0 Then
        LogDebug("WhereFieldEquals map empty!")
        Return
    End If
    Dim args As List
    args.Initialize
    For i = 0 To WhereFieldEquals.Size - 1
        If i > 0 Then sb.Append(" AND ")
        sb.Append("[").Append(WhereFieldEquals.GetKeyAt(i)).Append("] = ?")
        args.Add(WhereFieldEquals.GetValueAt(i))
    Next
    LogDebug("DeleteRecord: " & sb.ToString)
    SQL.ExecNonQuery2(sb.ToString, args)
End Sub

