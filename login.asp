<html>
<head>
<title>Bank project</title>
</head>
<body>



<% 
//Defined variables ---------------------------------------------------------
Dim adoCon , rsproject, strSQL, email, password

email = Request.Form("email")
password = Request.Form("password")

//'Create an ADO(ActiveX Data Objects) connection object--------------------
Set adoCon =  Server.CreateObject("ADODB.Connection")
'set an active connection to the Connectin object using a DSN-less connection ------------ 
adoCon.Open "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" & Server.MapPath("project.accdb") & ";Persist Security Info=False;"


//Create ADO recordset object ---------------------------------- 
Set rsproject = Server.CreateObject("ADODB.Recordset")

//Initialize the strSQL variables with an SQL statment to query the database ------------------------ 
strSQL = "SELECT * FROM data WHERE email ='"&email&"' AND password='"&password&"' "

//Open the recordest wiht the SQL query ----------------------------------------
rsproject.Open strSQL, adoCon

// EOF(End Of File), if their is record(object) found then the user authorized
If Not rsproject.EOF Then 
    Session("email") = email
    Response.Redirect("homepage.html") //! I will creat it later
Else 
    Response.Redirect("login_noMatch.html")
End If



//Reset server objects ----------------------------------------------------------
rsproject.Close
Set rsproject = Nothing
adoCon.Close
Set adoCon = Nothing



%>
    
</body>
</html>
<!-- adoCon.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("project.accdb") -->
