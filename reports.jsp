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
    <title>Invoice Reports</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="reports.css">
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
        .table {
            margin-top: 20px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.1);
        }
        .paid {
            color: #28a745;
            font-weight: bold;
        }
        .pending {
            color: #ffcc00;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 Invoice Reports</h2>
        <table class="table table-dark table-hover">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Customer</th>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Total Amount</th>
                    <th>Paid</th>
                    <th>Remaining</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");

                        String sql = "SELECT i.id, c.name AS customer, p.name AS product, ii.quantity, i.total_amount, " +
                                     "COALESCE(SUM(pay.amount), 0) AS paid, " +
                                     "(i.total_amount - COALESCE(SUM(pay.amount), 0)) AS remaining " +
                                     "FROM invoices i " +
                                     "JOIN customers c ON i.customer_id = c.id " +
                                     "JOIN invoice_items ii ON i.id = ii.invoice_id " +
                                     "JOIN products p ON ii.product_id = p.id " +
                                     "LEFT JOIN payments pay ON i.id = pay.invoice_id " +
                                     "GROUP BY i.id, c.name, p.name, ii.quantity, i.total_amount";

                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                            double remaining = rs.getDouble("remaining");
                            boolean isPaid = remaining == 0;
                %>
                <tr>
                    <td>#<%= rs.getInt("id") %></td>
                    <td><%= rs.getString("customer") %></td>
                    <td><%= rs.getString("product") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>₹<%= rs.getDouble("total_amount") %></td>
                    <td>₹<%= rs.getDouble("paid") %></td>
                    <td>₹<%= remaining %></td>
                    <td class="<%= isPaid ? "paid" : "pending" %>"><%= isPaid ? "Paid" : "Pending" %></td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
