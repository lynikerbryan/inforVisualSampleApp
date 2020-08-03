<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeTool_BACH.aspx.cs" Inherits="LaborEntryApp.TimeTool" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="Content/bootstrap.js"></script>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <script src="Scripts/Alertfy/alertify.min.js"></script>
    <link href="Content/alertify.core.css" rel="stylesheet" />
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/alertify.bootstrap.css" rel="stylesheet" />
    <title>Time Entry Tool - Bach-Simpson</title>
    <link rel="icon" type="image/png" href="Content/Images/bach_con.ico" />
    <style>
        /*this is a workaround for modal bug in bootstrap*/
        .fade.in {
            opacity: 1;
        }

        .modal.in .modal-dialog {
            -webkit-transform: translate(0, 0);
            -o-transform: translate(0, 0);
            transform: translate(0, 0);
        }

        .modal-backdrop.in {
            opacity: 0.5;
        }

        .alert-primary {
            color: #040404;
            background-color: rgba(108, 117, 125, 0.43137254901960786);
            border-color: #bdbfc1;
        }

        .btn-primary {
            color: #fff;
            background-color: #454648;
            border-color: #7b7d7f;
        }

            .btn-primary:hover {
                color: #fff;
                background-color: #6b6c6f;
                border-color: #818284
            }

            .btn-primary.disabled, .btn-primary:disabled {
                color: #fff;
                background-color: #989a9c;
                border-color: #93979a
            }

            .btn-primary.focus, .btn-primary:focus {
                box-shadow: 0 0 0 .2rem rgba(129, 174, 222, 0.5)
            }

        body {
            padding-top: 75px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" defaultbutton="btnCheck">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="fixed-top">
            <nav class="navbar navbar-dark bg-dark">
                <div class="container">
                    <a class="navbar-brand" href="#">
                        <img src="Content/Images/bach-simpsons-logo.png" width="30" height="30" alt="" />
                        Bach-Simpson
                    </a>
                </div>
            </nav>

            <asp:UpdatePanel ID="updatePanelProgress" runat="server">
                <ContentTemplate>
                    <fieldset>
                        <div class="progress" style="visibility: hidden; margin: 0px 0 5px 0;" id="progressdiv" runat="server">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="45" aria-valuemin="0" aria-valuemax="100" style="height: 15px; width: 100%">
                            </div>
                        </div>
                    </fieldset>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <div class="container" runat="server">
            <div class="row">
                <div class="col">
                    <div class="card" style="width: 69rem;">
                        <div class="card-body">
                            <div class="form-row">
                                <div class="col-auto">
                                    <h5 class="card-title" style="display: inline">TIME TICKET</h5>
                                </div>

                                <div class="col-auto" id="divVersion" runat="server">
                                    <%-- version div content --%>
                                </div>
                            </div>
                            <div class="form-row align-items-center">

                                <div class="col-auto">
                                    <asp:Label Text="Date" runat="server"></asp:Label><br />
                                    <input id="iptDate" class="form-control" runat="server" type="date" />
                                </div>
                                <asp:UpdatePanel ID="updatePanelLoadButton" runat="server">
                                    <ContentTemplate>
                                        <fieldset>
                                            <div class="col-auto">
                                                <asp:Button CssClass="btn btn-outline-primary mb-2" Text="Load tickets" ID="btnGoDate" Style="margin-top: 30px; margin-bottom: 0px;" runat="server" OnClick="btnGoDate_Click" OnClientClick="progressBar()" />
                                            </div>
                                        </fieldset>
                                    </ContentTemplate>
                                </asp:UpdatePanel>

                                <div class="form-row alert alert-primary" style="margin-top:25px;">
                                    <asp:UpdatePanel ID="updatePanelHours" UpdateMode="Conditional" runat="server">
                                        <ContentTemplate>
                                            <fieldset>
                                                <div class="col-auto" style="margin-top: 5px; margin-bottom: 0px; margin-left: 5px;">
                                                    <asp:Label Text="" ID="lblTotalHours" runat="server"></asp:Label>
                                                </div>
                                            </fieldset>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>

                                    <div class="col-auto" style="text-align-last: center; margin-top: 5px; margin-bottom: 0px; margin-left: 5px;">
                                        <asp:Label Text="" ID="lblEmpInfo" runat="server"></asp:Label>
                                    </div>
                                </div>

                                <div class="col-auto alert alert-primary" style="margin-top: 5px; margin-bottom: 0px; margin-left: 15px; font-size: 23px;">
                                    <asp:Label Text="" ID="lblPeriodInfo" runat="server"></asp:Label>
                                </div>

                                <div class="col-auto" style="margin-left: 0px">
                                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
                                        Holidays
                                    </button>
                                </div>

                            </div>


                            <div class="form-row align-items-center" style="margin: 0px 0 10px 0;">
                                <div class="col-auto">
                                    <label for="tbxBz">Bugzilla item ID</label>
                                    <asp:TextBox TextMode="Number" CssClass="form-control" ID="tbxBz" Width="150px" runat="server" onblur="setBackground(this)"></asp:TextBox>
                                </div>

                                <div class="col-auto">
                                    <asp:Button CssClass="btn btn-outline-primary mb-2" ID="btnCheck" Style="margin-top: 40px; margin-bottom: 0px;" runat="server" Text="Check" OnClientClick="return disableCheckButton()" OnClick="btnCheck_Click" />
                                </div>

                                <div runat="server" id="divbuginfo" class="col-auto alert alert-primary" style="margin-top: 30px; margin-bottom: 0px; margin-left: 30px; display: none;">
                                    <asp:Label runat="server" ID="lblProductName" Text=""></asp:Label>
                                    <asp:Label runat="server" ID="lblProductDesc" Text=""></asp:Label>
                                </div>

                                <div runat="server" id="editbuginfo" class="col-auto alert alert-primary" style="margin-top: 30px; margin-bottom: 0px; margin-left: 30px; visibility: hidden;">
                                    <asp:Label runat="server" ID="lblTicketInfo" Text="test"></asp:Label>
                                </div>
                            </div>

                            <div class="form-row align-items-center" style="margin: 10px 0 20px 0;">
                                <div class="col-auto">
                                    <asp:Label Text="Indirect" runat="server" CssClass="label"></asp:Label><br />
                                    <asp:DropDownList CssClass="form-control" Width="300" ID="ddlInd" runat="server" onblur="setBackground(this)"></asp:DropDownList>
                                </div>

                                <div class="col-auto">
                                    <asp:Label ID="Label1" runat="server" Text="WO No"></asp:Label><br />
                                    <asp:TextBox CssClass="form-control" ID="dplWoPo" Width="300" runat="server" AutoPostBack="true"></asp:TextBox>
                                </div>
                                <asp:UpdatePanel ID="updatePanelLeg" UpdateMode="Conditional" style="width: 35%;" runat="server">
                                    <ContentTemplate>
                                        <fieldset>
                                            <div class="form-row align-items-center" style="margin-top: 3px;">
                                                <div class="col-auto">
                                                    <asp:Label runat="server" Text="Leg"></asp:Label><br />
                                                    <asp:DropDownList CssClass="form-control" AutoPostBack="true" Width="175" ID="ddlLeg" runat="server" onchange="progressBar()" OnSelectedIndexChanged="ddlLeg_SelectedIndexChanged"></asp:DropDownList>
                                                </div>

                                                <div class="col-auto">
                                                    <asp:Label Text="Opn" runat="server"></asp:Label><br />
                                                    <asp:DropDownList CssClass="form-control" Width="175" ID="ddlOpn" runat="server" onblur="setBackground(this)"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>

                            <div class="form-row align-items-center" style="margin: 10px 0 20px 0;">
                                <div class="col-auto">
                                    <asp:Label Text="Hours worked" runat="server"></asp:Label><br />
                                    <asp:TextBox CssClass="form-control" Width="150px" ID="txtHours" runat="server" onblur="setBackground(this)"></asp:TextBox>
                                </div>

                                <div class="col-auto">
                                    <asp:Label Text="Category" runat="server"></asp:Label><br />
                                    <asp:DropDownList CssClass="form-control" Width="100px" ID="ddlOver" onblur="setBackground(this)" runat="server">
                                        <asp:ListItem Text="NO">NO</asp:ListItem>
                                        <asp:ListItem Text="OT">OT</asp:ListItem>
                                        <asp:ListItem Text="BK">BK</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="col-auto">
                                    <asp:Label CssClass="thirdlabel" Text="Work product" runat="server"></asp:Label><br />
                                    <asp:DropDownList CssClass="thirdlabel" Width="150px" ID="ddlWp" runat="server" onblur="setBackground(this)"></asp:DropDownList>
                                </div>

                                <div class="col-auto">
                                    <asp:Label CssClass="thirdlabel" Text="Task" runat="server"></asp:Label><br />
                                    <asp:DropDownList CssClass="thirdlabel" ID="ddlTk" Width="150px" onblur="setBackground(this)" runat="server"></asp:DropDownList>
                                </div>

                                <div class="col-auto">
                                    <asp:Label Text="Previous milestone" runat="server"></asp:Label><br />
                                    <asp:DropDownList CssClass="form-control" Width="150px" ID="ddlMil" onblur="setBackground(this)" runat="server">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-auto">
                                    <asp:Label Text="Current milestone" runat="server"></asp:Label><br />
                                    <asp:DropDownList CssClass="form-control" Width="150px" ID="ddlCurMil" onblur="setBackground(this)" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <div class="form-row align-items-center" style="margin: 10px 0 20px 0;">
                                <div class="col-auto">
                                    <asp:Label Text="Comment" runat="server"></asp:Label><br />
                                    <asp:TextBox CssClass="form-control" Width="1000px" ID="txtComment" runat="server" onblur="setBackground(this)" />
                                </div>
                            </div>

                            <hr />

                            <span id="ldnSpan" runat="server"></span>

                            <div class="form-row align-items-center" id="divButtons" runat="server">

                                <div class="col-auto">
                                    <asp:Button ID="btnSave" CssClass="btn btn-primary mb-2" Text="Save" runat="server" OnClientClick="return checkFields()" OnClick="btnSave_Click" />
                                </div>

                                <div class="col-auto">
                                    <asp:Button ID="btnReset" CssClass="btn btn-primary mb-2" Text="Reset" OnClientClick="progressBar()" runat="server" OnClick="btnReset_Click" />
                                </div>

                                <div class="col-auto">
                                    <asp:Button ID="btnSaveEdit" CssClass="btn btn-primary mb-2" Text="Update" runat="server" OnClientClick="return checkFieldsUpdate()" OnClick="btnSaveEdit_Click" />
                                </div>

                                <div class="col-auto">
                                    <input type="button" id="btnCancel2" class="btn btn-primary mb-2" disabled="disabled" value="Cancel" runat="server" onclick="cancelEditRow()" />
                                </div>

                                <div class="col-auto">
                                    <asp:Button ID="btnDelete" CssClass="btn btn-primary mb-2" Text="Delete" runat="server" OnClientClick="return confirmBox()" OnClick="btnDelete_Click" />
                                </div>
                            </div>

                            <!-- this is a hidden input used when editing a ticket -->
                            <input id="ticketId" type="hidden" runat="server" />

                            <asp:UpdatePanel ID="updatePanelTable" UpdateMode="Conditional" runat="server">
                                <ContentTemplate>
                                    <fieldset>
                                        <div class="col-auto" style="text-align: center; margin-bottom: 20px;">
                                            <asp:Label CssClass="head" Text="List of tickets for" ID="lblTickets" runat="server" Style="font-size: 20px; font-weight: bold;"></asp:Label>
                                        </div>
                                        <div class="col-auto">
                                            <div class="col-auto" id="divtable" runat="server">
                                                <asp:Table CssClass="table table-sm table-bordered table table-hover thead-dark" Font-Size="Smaller" ID="tblTickets" runat="server" Width="100%">
                                                    <asp:TableHeaderRow Font-Size="Small" CssClass="thead-dark">
                                                        <asp:TableHeaderCell></asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>LB. No</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>WO/Indirect</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>Leg</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>Resource</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>Hours worked</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>Category</asp:TableHeaderCell>
                                                        <asp:TableHeaderCell>Description</asp:TableHeaderCell>
                                                    </asp:TableHeaderRow>
                                                </asp:Table>
                                            </div>
                                        </div>
                                    </fieldset>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- Holiday Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List of holidays</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <asp:Table CssClass="able table-sm table-bordered table table-hover thead-dark" Font-Size="Small" ID="tblHolidays" runat="server">
                        <asp:TableHeaderRow CssClass="thead-dark">
                            <asp:TableHeaderCell>Date</asp:TableHeaderCell>
                            <asp:TableHeaderCell>Day</asp:TableHeaderCell>
                            <asp:TableHeaderCell>Description</asp:TableHeaderCell>
                        </asp:TableHeaderRow>
                    </asp:Table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
    //check browser version
    //this is to make sure field checking typing works
    //ele.which works on Chrome but not on Firefox, so we have to use ele.charCode for Firefox.
    if (navigator.userAgent.indexOf("Firefox") != -1) {//add event to firefox
        var element1 = document.getElementById('<%= txtHours.ClientID %>');
        element1.addEventListener("keypress", checkHoursFirefox, false);
    } else {//any other case
        var element2 = document.getElementById('<%= txtHours.ClientID %>');
        element2.addEventListener("keypress", checkHours, false);
    }

    //adding comment listener to check its size
    var element3 = document.getElementById('<%= txtComment.ClientID %>');
    element3.addEventListener("keypress", checkCommentLength, false);

    //this is needed to re aplly the atrribute after the element is modified
    document.getElementById("ddlWp").className = "form-control";
    document.getElementById("ddlTk").className = "form-control";

    //addding key event to the comment text box
    //checks of the description is longer than 80 chars.
    function checkCommentLength(ele) {
        var finalWorkProd = document.getElementById('<%= ddlWp.ClientID %>').value;
        finalWorkProd = finalWorkProd.substring(0, finalWorkProd.indexOf('-'));
        finalWorkProd = (finalWorkProd == "" ? "-" : finalWorkProd);

        var finalTask = document.getElementById('<%= ddlTk.ClientID %>').value;
        finalTask = finalTask.substring(0, finalTask.indexOf('-'));
        finalTask = (finalTask == "" ? "-" : finalTask);

        var finalMilistone = document.getElementById('<%= ddlMil.ClientID %>').value;
        finalMilistone = finalMilistone.substring(0, finalMilistone.indexOf('-'));
        finalMilistone = (finalMilistone == "" ? "-" : finalMilistone);

        var finalCurMilistone = document.getElementById('<%= ddlCurMil.ClientID %>').value;
        finalCurMilistone = finalCurMilistone.substring(0, finalCurMilistone.indexOf('-'));
        finalCurMilistone = (finalCurMilistone == "" ? "-" : finalCurMilistone);

        var bzItem = document.getElementById('<%= tbxBz.ClientID %>').value;
        bzItem = (bzItem == "" ? "-" : ("B" + bzItem));

        var txtComment = document.getElementById('<%= txtComment.ClientID %>').value;

        var finalComment = "";
        if (document.getElementById('<%= ddlOver.ClientID %>').value == "OT") {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "OT" + ",&" + txtComment;
        }
        else if (document.getElementById('<%= ddlOver.ClientID %>').value == "BK") {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "BK" + ",&" + txtComment;
        }
        else {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "" + ",&" + txtComment;
        }

        if (finalComment.length + 1 > 80) {
            alertify.error("Your comment cannot be any longer.");
            ele.preventDefault();//refuse the input
        }

    }

    //addding key event to the comment text box
    //this will block comma and & from being entered into the text field
    var element = document.getElementById('<%= txtComment.ClientID %>');
    element.addEventListener("keypress", checkComment, false);
    function checkComment(ele) {
        if (ele.charCode == "44" || ele.charCode == "38") {
            ele.preventDefault();
        }
    }

    //adding key event to hours text box    
    //this blocks anthing besides numbers and dot (.)
    function checkHours(ele) {
        if (ele.keyCode != 46) {
            if (ele.which < 48 || ele.which > 57) {
                ele.preventDefault();
            }
        }
    }

    //addding key event to the comment text box FOR MOZILLA FIREFOX
    //this will block comma and & from being entered into the text field
    function checkHoursFirefox(ele) {
        if (ele.charCode != 46) {
            if (ele.charCode < 48 || ele.charCode > 57) {
                if ((ele.keyCode < 37 || ele.keyCode > 40) && ele.code != "Backspace") {
                    ele.preventDefault();
                }
            }
        }
    }

    //check if the hour field is valid
    function checkHourField() {
        var hr = document.getElementById('<%= txtHours.ClientID %>').value;
        if (isNaN(hr)) {
            alertify.alert("Hour is an invalid value.");
            return false;
        } else {
            if (!hr == "" || !hr == null) {
                hr = parseFloat(hr);
                if (hr <= 0) {
                    alertify.error("Hours field cannot be negative or zero");
                    return false;
                } else {
                    return true;
                }
            }
        }
    }

    //set the border back to normal after an element is highlighted
    function setBackground(ele) {
        ele.style.border = "1px solid #ced4da";
    }

    //check if the indirect is an exception. These indirects do not need comment 
    function checkNoWPMandatory() {
        if (document.getElementById('<%= ddlInd.ClientID %>').value == "10011-HOLIDAYS" || document.getElementById('<%= ddlInd.ClientID %>').value == "10012-VACATION" || document.getElementById('<%= ddlInd.ClientID %>').value == "10013-SICKNESS" || document.getElementById('<%= ddlInd.ClientID %>').value == "10016-OUT OF OFFICE PERSONAL" || document.getElementById('<%= ddlInd.ClientID %>').value == "10017-ESA PERSONAL LEAVE")
            return true;
        else {
            return false;
        }
    }

    //check if bug was checked
    function checkIfBugChecked() {
        if (document.getElementById('<%= btnCheck.ClientID %>').value == "Check" && document.getElementById('<%= tbxBz.ClientID %>').value != "") {
            alertify.alert("You typed a bugzilla item but did not press Check. If you do not wish to link this time entry to a bugzilla item, please delete the bugzilla item typed and try again.");
            return false;
        } else {
            return true;
        }
    }

    //check comment lenght
    function checkDescLenght() {
        var finalWorkProd = document.getElementById('<%= ddlWp.ClientID %>').value;
        finalWorkProd = finalWorkProd.substring(0, finalWorkProd.indexOf('-'));
        finalWorkProd = (finalWorkProd == "" ? "-" : finalWorkProd);

        var finalTask = document.getElementById('<%= ddlTk.ClientID %>').value;
        finalTask = finalTask.substring(0, finalTask.indexOf('-'));
        finalTask = (finalTask == "" ? "-" : finalTask);

        var finalMilistone = document.getElementById('<%= ddlMil.ClientID %>').value;
        finalMilistone = finalMilistone.substring(0, finalMilistone.indexOf('-'));
        finalMilistone = (finalMilistone == "" ? "-" : finalMilistone);

        var finalCurMilistone = document.getElementById('<%= ddlCurMil.ClientID %>').value;
        finalCurMilistone = finalCurMilistone.substring(0, finalCurMilistone.indexOf('-'));
        finalCurMilistone = (finalCurMilistone == "" ? "-" : finalCurMilistone);

        var bzItem = document.getElementById('<%= tbxBz.ClientID %>').value;
        bzItem = (bzItem == "" ? "-" : ("B" + bzItem));

        var txtComment = document.getElementById('<%= txtComment.ClientID %>').value;

        var finalComment = "";
        if (document.getElementById('<%= ddlOver.ClientID %>').value == "OT") {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "OT" + ",&" + txtComment;
        }
        else if (document.getElementById('<%= ddlOver.ClientID %>').value == "BK") {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "BK" + ",&" + txtComment;
        }
        else {
            finalComment = finalWorkProd + "," + finalTask + "," + finalMilistone + "," + finalCurMilistone + "," + bzItem + "," + "" + ",&" + txtComment;
        }

        if (finalComment.length > 80) {
            alertify.alert("Your comment is " + (finalComment.length - 80) + " characters too long.");
            return false;
        }
        else {
            return true;
        };
    }

    //check all the mandatory fields before saving a new ticket
    function checkFields() {

        if(!checkIfBugChecked()){
            return false;
        }

        if (!checkDescLenght()) {
            return false;
        }

        var dplWoPo = document.getElementById('<%= dplWoPo.ClientID %>').value;
        var tbxBz = document.getElementById('<%= tbxBz.ClientID %>').value;
        var ddlIn = document.getElementById('<%= ddlInd.ClientID %>').value;
        var txtHours = document.getElementById('<%= txtHours.ClientID %>').value;
        var ddlWp = document.getElementById('<%= ddlWp.ClientID %>').value;
        var ddlTk = document.getElementById('<%= ddlTk.ClientID %>').value;
        var txtComment = document.getElementById('<%= txtComment.ClientID %>').value;
        var ddlOpn = document.getElementById('<%= ddlOpn.ClientID %>').value;

        if (dplWoPo == "" && tbxBz == "" && !checkNoWPMandatory()) {//indirect new ticket
            if (ddlIn == "-" || txtHours == "" || ddlWp == "-" || ddlTk == "-" || txtComment == "") {

                if (document.getElementById('<%= ddlInd.ClientID %>').value == "-")
                    document.getElementById('<%= ddlInd.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= txtComment.ClientID %>').value == "")
                    document.getElementById('<%= txtComment.ClientID %>').style.border = "1px solid red";

                alertify.error("There are mandatory fields missing.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (dplWoPo != "") {//direct new ticket
            if (tbxBz == "" || ddlOpn == "" || txtHours == "" || ddlWp == "-" || ddlTk == "-") {

                if (document.getElementById('<%= ddlOpn.ClientID %>').value == "") {
                    document.getElementById('<%= ddlOpn.ClientID %>').style.border = "1px solid red";
                    document.getElementById('<%= ddlLeg.ClientID %>').style.border = "1px solid red";

                }
                if (document.getElementById('<%= tbxBz.ClientID %>').value == "")
                    document.getElementById('<%= tbxBz.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                alertify.error("There are mandatory fields missing.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (dplWoPo == "" && tbxBz != "" && !checkNoWPMandatory()) {//indirect with bugzilla ticket
            if (txtHours == "" || ddlWp == "-") {

                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                alertify.error("Hours worked, Work product and Task fields cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (dplWoPo == "" && checkNoWPMandatory()) {//indirect for vacation, holiday, out of office, sickness

            if (document.getElementById('<%= txtHours.ClientID %>').value == "") {
                document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";
                alertify.error("Hours worked field cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        }
    }

    //check all the mandatory fields before updating a ticket
    function checkFieldsUpdate() {

        if (!checkDescLenght()) {
            return false;
        }

        var dplWoPo = document.getElementById('<%= dplWoPo.ClientID %>').value;
        var tbxBz = document.getElementById('<%= tbxBz.ClientID %>').value;
        var ddlIn = document.getElementById('<%= ddlInd.ClientID %>').value;
        var txtHours = document.getElementById('<%= txtHours.ClientID %>').value;
        var ddlWp = document.getElementById('<%= ddlWp.ClientID %>').value;
        var ddlTk = document.getElementById('<%= ddlTk.ClientID %>').value;
        var txtComment = document.getElementById('<%= txtComment.ClientID %>').value;

        if (dplWoPo == "" && tbxBz == "" && !checkNoWPMandatory()) {//indirect ticket

            if (txtHours == "" || ddlWp == "-" || ddlTk == "-" || txtComment == "") {
                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= txtComment.ClientID %>').value == "")
                    document.getElementById('<%= txtComment.ClientID %>').style.border = "1px solid red";

                alertify.error("Hours worked, Work product, Task and Comment fields cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (ddlIn == "-") {//direct ticket
            if (txtHours == "" || ddlWp == "-" || ddlTk == "-") {

                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                alertify.error("Hours worked, Work product and Task fields cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (dplWoPo == "" && tbxBz != "" && !checkNoWPMandatory()) {//indirect with bugzilla item
            if (txtHours == "" || ddlWp == "-" || ddlTk == "-") {

                if (document.getElementById('<%= txtHours.ClientID %>').value == "")
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlWp.ClientID %>').value == "-")
                    document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";

                if (document.getElementById('<%= ddlTk.ClientID %>').value == "-")
                    document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";

                alertify.error("Hours worked, Work product and Task fields cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        } else if (dplWoPo == "" && checkNoWPMandatory()) {//indirect ticket for holiday, sickness etc
            if (document.getElementById('<%= txtHours.ClientID %>').value == "") {
                if (document.getElementById('<%= txtHours.ClientID %>').value == "") {
                    document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";
                }
                alertify.error("Hours worked field cannot be empty.");
                return false;
            } else {
                if (checkHourField()) {
                    disableButtonDiv();
                    progressBar();
                    return true;
                } else {
                    return false;
                }
            }
        }
    }

    //check if bugzilla text field is empty 
    function checkBug() {
        if (document.getElementById('<%= tbxBz.ClientID %>').value == "") {
            alertify.error("Bugzilla item field is empty.");
            return false;
        } else {
            disableCheckButton();
        }
    }


    //confirmation box to delete a ticket
    function confirmBox() {
        if (confirm("Do you wish to delete this ticket?")) {
            disableButtonDiv();
            progressBar();
            return true;
        } else {
            return false;
        }
    }

    //disabling check button after a click
    function disableCheckButton() {
        if (document.getElementById('<%= tbxBz.ClientID %>').value == "") {
            alertify.error("Bugzilla item field is empty.");
            return false;
        } else if (document.getElementById('<%= btnCheck.ClientID %>').value == "Change bug") {
            document.getElementById('<%= tbxBz.ClientID %>').readOnly = false;
            document.getElementById('<%= tbxBz.ClientID %>').value = "";
            document.getElementById('<%= btnCheck.ClientID %>').value = "Check";
            document.getElementById('<%= dplWoPo.ClientID %>').value = ""
            document.getElementById('<%= dplWoPo.ClientID %>').disabled = false;
            document.getElementById('<%= ddlLeg.ClientID %>').options.length = 0;
            document.getElementById('<%= ddlOpn.ClientID %>').options.length = 0;
            document.getElementById('<%= divbuginfo.ClientID %>').style.display = "none";
            document.getElementById('<%= ddlInd.ClientID %>').disabled = false;
            document.getElementById('<%= ddlLeg.ClientID %>').disabled = false;
            document.getElementById('<%= ddlOpn.ClientID %>').disabled = false;
            return false;
        } else {
            progressBar();
            return true;
        }
    }

    //disable buttons div
    function disableButtonDiv() {
        document.getElementById('<%= ldnSpan.ClientID %>').textContent = "Working on that..."
        document.getElementById('<%= divButtons.ClientID %>').style.visibility = "hidden";
    }

    //set to visible the progress bar div
    function progressBar() {
        document.getElementById("progressdiv").style.visibility = "visible";
    }

    //edit ticket button function
    function editTicketRow(ele) {
        var comment = ele.parentElement.cells[7].textContent.split(',');//split the comment field

        document.getElementById('<%= divbuginfo.ClientID %>').style.display = "none";
        document.getElementById('<%= editbuginfo.ClientID %>').style.visibility = "visible";
        document.getElementById('<%= lblTicketInfo.ClientID %>').innerHTML = "<strong>Editing labor ticket number: " + ele.parentElement.cells[1].textContent + "</strong>";
        document.getElementById('<%= lblProductDesc.ClientID %>').innerHTML = "";
        document.getElementById('<%= ticketId.ClientID %>').value = ele.parentElement.cells[1].textContent;
        document.getElementById('<%= btnGoDate.ClientID %>').disabled = true;
        document.getElementById('<%= btnCheck.ClientID %>').disabled = true;
        //document.getElementById('<%= tbxBz.ClientID %>').disabled = true;
        document.getElementById('<%= tbxBz.ClientID %>').readOnly = true;
        document.getElementById("btnCancel2").disabled = false;
        document.getElementById("btnDelete").disabled = false;
        document.getElementById('<%= btnSaveEdit.ClientID %>').disabled = false;
        document.getElementById('<%= btnReset.ClientID %>').disabled = true;
        document.getElementById('<%= btnSave.ClientID %>').disabled = true;

        //checking if it is a indirect ticket
        var ind = ele.parentElement.cells[4].textContent;
        if (ind === " ") {
            document.getElementById('<%= ddlInd.ClientID %>').value = ele.parentElement.cells[2].textContent;
            document.getElementById('<%= dplWoPo.ClientID %>').value = "";

            var bugid = comment[4];
            //if the ticket has a bug make indirect dropdown disabled
            if (bugid != "-") {
                document.getElementById('<%= ddlInd.ClientID %>').disabled = true;
                document.getElementById('<%= ddlInd.ClientID %>').style.border = "1px solid #ced4da";
            } else {
                document.getElementById('<%= ddlInd.ClientID %>').disabled = false;
                document.getElementById('<%= ddlInd.ClientID %>').style.border = "1px solid red";
            }

        } else {
            document.getElementById('<%= dplWoPo.ClientID %>').value = ele.parentElement.cells[2].textContent;
            document.getElementById('<%= ddlInd.ClientID %>').selectedIndex = 0;
            document.getElementById('<%= ddlInd.ClientID %>').disabled = true;
            document.getElementById('<%= ddlInd.ClientID %>').style.border = "1px solid #ced4da";
        }

        document.getElementById('<%= txtHours.ClientID %>').value = ele.parentElement.cells[5].textContent
        document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid red";
        document.getElementById('<%= ddlOver.ClientID %>').value = ele.parentElement.cells[6].textContent;
        document.getElementById('<%= ddlOver.ClientID %>').style.border = "1px solid red";

        var ddl = document.getElementById('<%= ddlWp.ClientID %>');
        for (var i = 0; i <= ddl.length - 1; i++) {
            var wp = ddl[i].value;
            wp = wp.substring(0, wp.indexOf('-'));
            if (comment[0] == wp) {
                document.getElementById('<%= ddlWp.ClientID %>').value = ddl[i].value;
            } else if (comment[0] == "-") {
                document.getElementById('<%= ddlWp.ClientID %>').value = "-";
            }
        }

        var ddl = document.getElementById('<%= ddlTk.ClientID %>');
        for (var i = 1; i <= ddl.length - 1; i++) {
            var tk = ddl[i].value;
            tk = tk.substring(0, tk.indexOf('-'));
            if (comment[1] == tk) {
                document.getElementById('<%= ddlTk.ClientID %>').value = ddl[i].value;
            } else if (comment[1] == "-") {
                document.getElementById('<%= ddlTk.ClientID %>').value = "-";
            }
        }

        var ddl = document.getElementById('<%= ddlMil.ClientID %>');
        for (var i = 1; i <= ddl.length - 1; i++) {
            var mil = ddl[i].value;
            mil = mil.substring(0, mil.indexOf('-'));
            if (comment[2] == mil) {
                document.getElementById('<%= ddlMil.ClientID %>').value = ddl[i].value;
            }
            else if (comment[2] == "-") {
                document.getElementById('<%= ddlMil.ClientID %>').value = "-";
            }
        }

        var ddl = document.getElementById('<%= ddlCurMil.ClientID %>');
        for (var i = 1; i <= ddl.length - 1; i++) {
            var mil = ddl[i].value;
            mil = mil.substring(0, mil.indexOf('-'));
            if (comment[3] == mil) {
                document.getElementById('<%= ddlCurMil.ClientID %>').value = ddl[i].value;
            } else if (comment[3] == "-") {
                document.getElementById('<%= ddlCurMil.ClientID %>').value = "-";
            }
        }
        document.getElementById('<%= ddlLeg.ClientID %>').options.length = 0;
        document.getElementById('<%= ddlOpn.ClientID %>').options.length = 0;
        document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid red";
        document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid red";
        document.getElementById('<%= ddlMil.ClientID %>').style.border = "1px solid red";
        document.getElementById('<%= ddlCurMil.ClientID %>').style.border = "1px solid red";

        //checking if the description has a bug 
        if (comment[4] === "-") {
            document.getElementById('<%= tbxBz.ClientID %>').value = "";
            document.getElementById('<%= tbxBz.ClientID %>').readOnly = true;
        } else {
            document.getElementById('<%= tbxBz.ClientID %>').value = comment[4].substring(1);//from "B26400" to "26400"
            document.getElementById('<%= tbxBz.ClientID %>').readOnly = true;
        }

        document.getElementById('<%= txtComment.ClientID %>').value = comment[6].substring(1);
        document.getElementById('<%= txtComment.ClientID %>').style.border = "1px solid red";
    }

    //cancel ticket button function
    function cancelEditRow() {
        document.getElementById('<%= lblTicketInfo.ClientID %>').innerHTML = "";
        document.getElementById('<%= ticketId.ClientID %>').value = "";
        document.getElementById('<%= editbuginfo.ClientID %>').style.visibility = "hidden";
        document.getElementById('<%= btnGoDate.ClientID %>').disabled = false;
        document.getElementById('<%= btnCheck.ClientID %>').disabled = false;
        document.getElementById('<%= tbxBz.ClientID %>').readOnly = false;
        document.getElementById("btnCancel2").disabled = true;
        document.getElementById("btnDelete").disabled = true;
        document.getElementById('<%= btnSaveEdit.ClientID %>').disabled = true;
        document.getElementById('<%= btnReset.ClientID %>').disabled = false;
        document.getElementById('<%= btnSave.ClientID %>').disabled = false;
        document.getElementById('<%= ddlInd.ClientID %>').selectedIndex = 0;
        document.getElementById('<%= ddlInd.ClientID %>').disabled = false;
        document.getElementById('<%= ddlInd.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlLeg.ClientID %>').options.length = 0;
        document.getElementById('<%= ddlOpn.ClientID %>').options.length = 0;
        document.getElementById('<%= dplWoPo.ClientID %>').value = "";
        document.getElementById('<%= txtHours.ClientID %>').value = ""
        document.getElementById('<%= txtHours.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlOver.ClientID %>').value = "NO";
        document.getElementById('<%= ddlOver.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlWp.ClientID %>').value = "-";
        document.getElementById('<%= ddlWp.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlTk.ClientID %>').value = "-";
        document.getElementById('<%= ddlTk.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlMil.ClientID %>').value = "-";
        document.getElementById('<%= ddlMil.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlCurMil.ClientID %>').value = "-";
        document.getElementById('<%= ddlCurMil.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlLeg.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= ddlOpn.ClientID %>').style.border = "1px solid #ced4da";
        document.getElementById('<%= tbxBz.ClientID %>').value = "";
        document.getElementById('<%= tbxBz.ClientID %>').disabled = false;
        document.getElementById('<%= txtComment.ClientID %>').value = "";
        document.getElementById('<%= txtComment.ClientID %>').style.border = "1px solid #ced4da";
        if (document.getElementById('<%= btnCheck.ClientID %>').value == "Change bug")
            document.getElementById('<%= btnCheck.ClientID %>').value = "Check";
    }
</script>


</html>
