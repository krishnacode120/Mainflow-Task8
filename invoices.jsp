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
    <title>Manage Invoices</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="invoices.css">
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
        <h2>🧾 Create New Invoice</h2>
        <form action="InvoiceServlet" method="post">
            <select name="customer_id" class="form-control" required>
                <option value="">Select Customer</option>
                <%
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
                    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customers");
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                <%
                    }
                    rs.close();
                    stmt.close();
                %>
            </select><br>
            <select name="product_id" class="form-control" required>
                <option value="">Select Product</option>
                <%
                    PreparedStatement stmt2 = conn.prepareStatement("SELECT * FROM products");
                    ResultSet rs2 = stmt2.executeQuery();
                    while (rs2.next()) {
                %>
                <option value="<%= rs2.getInt("id") %>"><%= rs2.getString("name") %> - ₹<%= rs2.getDouble("price") %></option>
                <%
                    }
                    rs2.close();
                    stmt2.close();
                    conn.close();
                %>
            </select><br>
            <input type="number" name="quantity" class="form-control" placeholder="Quantity" required><br>
            <button type="submit" class="btn btn-primary">Create Invoice</button>
             
        </form>

        <h3 class="mt-4">📃 Invoice List</h3>
        <table class="table table-dark table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Total</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
                    PreparedStatement stmt3 = conn2.prepareStatement("SELECT * FROM invoices");
                    ResultSet rs3 = stmt3.executeQuery();
                    while (rs3.next()) {
                %>
                <tr>
                    <td><%= rs3.getInt("id") %></td>
                    <td><%= rs3.getInt("customer_id") %></td>
                    <td>₹<%= rs3.getDouble("total_amount") %></td>
                    <td><%= rs3.getDate("date") %></td>
                </tr>
                <%
                    }
                    rs3.close();
                    stmt3.close();
                    conn2.close();
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
