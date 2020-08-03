<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="LaborEntryApp.ErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Error page - Bach-Simpson</title>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="Content/bootstrap.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <script src="Scripts/Alertfy/alertify.min.js"></script>
    <link href="Content/alertify.core.css" rel="stylesheet" />
    <link href="Content/alertify.bootstrap.css" rel="stylesheet" />
    <link rel="icon" type="image/png" href="Content/Images/bach_con.ico" />
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar navbar-dark bg-dark">
        <a class="navbar-brand" href="#">
            <img src="Content/Images/bach-simpsons-logo.png" width="30" height="30" alt="" />
            Bach-Simpson
        </a>
    </nav>
   
    <div class="container" runat="server" style="margin-top:30px;">
        <p>Something happened and we could not complete the task.</p>
        <p>Error details:</p>
        <asp:Label ID="details" runat="server"></asp:Label>
    </div>
    </form>
</body>
</html>
