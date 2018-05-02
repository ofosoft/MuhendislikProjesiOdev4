<% 
	vtadi="db"
	vtyolu="db"
	db_veriyolu ="/" & vtyolu & "/"& vtadi &""

	set Baglantim = server.createobject("adodb.connection")
	Baglantim.open "provider=microsoft.jet.oledb.4.0;data source=" & Server.mappath(db_veriyolu & ".mdb")

	Set Rs=Server.CreateObject("Adodb.Recordset")
	Set Ra=Server.CreateObject("Adodb.Recordset")
	Set Rf=Server.CreateObject("Adodb.Recordset")
	Set Ru=Server.CreateObject("Adodb.Recordset")
%>