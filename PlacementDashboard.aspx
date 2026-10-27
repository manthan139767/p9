
<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="PlacementDashboard.aspx.cs"
    Inherits="P9.PlacementDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Placement Dashboard</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1" />

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #243047;
        }

        .header {
            background: #183153;
            color: white;
            padding: 25px 35px;
        }

        .header h1 {
            margin: 0 0 8px;
            font-size: 28px;
        }

        .header p {
            margin: 0;
            color: #d6e2f3;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 3px 12px #0000000d;
            border-top: 4px solid #3478db;
        }

        .card h3 {
            margin: 0 0 12px;
            color: #64748b;
            font-size: 15px;
        }

        .number {
            font-size: 32px;
            font-weight: bold;
            color: #183153;
        }

        .panel {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 12px #0000000d;
            margin-bottom: 25px;
            overflow-x: auto;
        }

        .panel h2 {
            margin-top: 0;
            font-size: 21px;
        }

        .search-box {
            padding: 10px;
            width: 260px;
            max-width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 5px;
            background: #3478db;
            color: white;
            cursor: pointer;
            margin-left: 5px;
        }

        .btn:hover {
            background: #245db0;
        }

        .grid {
            width: 100%;
            border-collapse: collapse;
            min-width: 650px;
        }

        .grid th {
            background: #183153;
            color: white;
            padding: 13px;
            text-align: left;
        }

        .grid td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .grid tr:nth-child(even) {
            background: #f8fafc;
        }

        .message {
            display: block;
            margin-top: 12px;
            color: #b91c1c;
        }

        @media (max-width: 700px) {
            .cards {
                grid-template-columns: 1fr;
            }

            .header {
                padding: 22px;
            }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

        <div class="header">
            <h1>Placement Dashboard</h1>
            <p>Student Placement Management System | P9</p>
        </div>

        <div class="container">

            <div class="cards">

                <div class="card">
                    <h3>Total Students</h3>
                    <asp:Label ID="lblTotalStudents"
                        runat="server"
                        CssClass="number"
                        Text="0" />
                </div>

                <div class="card">
                    <h3>Students Placed</h3>
                    <asp:Label ID="lblPlaced"
                        runat="server"
                        CssClass="number"
                        Text="0" />
                </div>

                <div class="card">
                    <h3>Placement Percentage</h3>
                    <asp:Label ID="lblPercentage"
                        runat="server"
                        CssClass="number"
                        Text="0%" />
                </div>

            </div>

            <div class="panel">
                <h2>Student Placement Records</h2>

                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="search-box"
                    placeholder="Search student or enrollment..." />

                <asp:Button ID="btnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="btn"
                    OnClick="btnSearch_Click" />

                <asp:Button ID="btnShowAll"
                    runat="server"
                    Text="Show All"
                    CssClass="btn"
                    OnClick="btnShowAll_Click" />

                <br /><br />

                <asp:GridView ID="gvStudents"
                    runat="server"
                    CssClass="grid"
                    AutoGenerateColumns="False"
                    EmptyDataText="No student records found."
                    GridLines="None">

                    <Columns>
                        <asp:BoundField
                            DataField="EnrollmentNo"
                            HeaderText="Enrollment No" />

                        <asp:BoundField
                            DataField="StudentName"
                            HeaderText="Student Name" />

                        <asp:BoundField
                            DataField="Department"
                            HeaderText="Department" />

                        <asp:BoundField
                            DataField="PassingYear"
                            HeaderText="Passing Year" />

                        <asp:BoundField
                            DataField="CompanyName"
                            HeaderText="Company" />

                        <asp:BoundField
                            DataField="JobRole"
                            HeaderText="Job Role" />

                        <asp:BoundField
                            DataField="PackageLPA"
                            HeaderText="Package (LPA)"
                            DataFormatString="{0:F2}" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label
                                    runat="server"
                                    Text='<%# Convert.ToBoolean(Eval("IsPlaced")) ? "Placed" : "Not Placed" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                </asp:GridView>

                <asp:Label ID="lblMessage"
                    runat="server"
                    CssClass="message" />

            </div>

        </div>

    </form>
</body>
</html>
