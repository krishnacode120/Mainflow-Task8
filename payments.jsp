<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Process Payments</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="payments.css">
    <style>
        body {
            background: linear-gradient(135deg, #1c1c1e, #2a2a2e);
            color: #ffffff;
            font-family: 'Poppins', sans-serif;
            text-align: center;
        }
        .container {
            margin-top: 50px;
            padding: 30px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }
        select, input, button {
            margin-top: 10px;
            border-radius: 8px;
        }
        .table {
            margin-top: 20px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>💳 Process Payment</h2>
        <form action="PaymentServlet" method="post">
            <select name="invoice_id" class="form-control" required>
                <option value="">Select Invoice</option>
                <%
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM invoices");
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id") %>">Invoice #<%= rs.getInt("id") %> - ₹<%= rs.getDouble("total_amount") %></option>
                <%
                    }
                    rs.close();
                    stmt.close();
                %>
            </select><br>
            <input type="number" name="amount" class="form-control" placeholder="Payment Amount" required><br>
            <button type="submit" class="btn btn-primary">Submit Payment</button>
        </form>

        <h3 class="mt-4">📜 Payment Records</h3>
        <table class="table table-dark table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Invoice</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    PreparedStatement stmt2 = conn.prepareStatement("SELECT * FROM payments");
                    ResultSet rs2 = stmt2.executeQuery();
                    while (rs2.next()) {
                %>
                <tr>
                    <td><%= rs2.getInt("id") %></td>
                    <td>#<%= rs2.getInt("invoice_id") %></td>
                    <td>₹<%= rs2.getDouble("amount") %></td>
                    <td><%= rs2.getDate("payment_date") %></td>
                </tr>
                <%
                    }
                    rs2.close();
                    stmt2.close();
                    conn.close();
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
