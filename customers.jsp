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
    <title>Manage Customers</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="customers.css">
</head>
<body>
    <div class="container">
        <h2>👤 Manage Customers</h2>

        <!-- Add New Customer Form -->
        <div class="form-container">
            <h3>Add New Customer</h3>
           <form action="CustomerServlet" method="post">
    <input type="hidden" name="action" value="add">
    
    <input type="text" name="name" class="form-control" placeholder="Name" required autocomplete="name"><br>
    
    <input type="email" name="email" class="form-control" placeholder="Email" required autocomplete="email"><br>
    
    <input type="text" name="phone" class="form-control" placeholder="Phone" required autocomplete="tel"><br>
    
    <button type="submit" class="btn btn-success">Add Customer</button>
</form>
        </div>

        <!-- Customer List -->
        <h3 class="mt-4">📋 Customer List</h3>
        <table class="table table-dark table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
                        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customers");
                        ResultSet rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td>
                        <!-- Update Button -->
                        <button class="btn btn-warning btn-sm update-btn" 
                                data-id="<%= rs.getInt("id") %>" 
                                data-name="<%= rs.getString("name") %>" 
                                data-email="<%= rs.getString("email") %>" 
                                data-phone="<%= rs.getString("phone") %>">
                            ✏ Update
                        </button>

                        <!-- Delete Button -->
                        <a href="CustomerServlet?action=delete&id=<%= rs.getInt("id") %>" 
                           class="btn btn-danger btn-sm delete-btn"
                           onclick="return confirm('Are you sure you want to delete this customer?');">
                            🗑 Delete
                        </a>
                    </td>
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

    <!-- Update Customer Modal -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Update Customer</h3>
            <form action="CustomerServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="update-id">
                <input type="text" name="name" id="update-name" class="form-control" placeholder="Name" required><br>
                <input type="email" name="email" id="update-email" class="form-control" placeholder="Email" required><br>
                <input type="text" name="phone" id="update-phone" class="form-control" placeholder="Phone" required><br>
                <button type="submit" class="btn btn-primary">Update Customer</button>
            </form>
        </div>
    </div>

    <script>
        // Handle Update Button Click
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll(".update-btn").forEach(button => {
                button.addEventListener("click", function() {
                    document.getElementById("update-id").value = this.dataset.id;
                    document.getElementById("update-name").value = this.dataset.name;
                    document.getElementById("update-email").value = this.dataset.email;
                    document.getElementById("update-phone").value = this.dataset.phone;
                    document.getElementById("updateModal").style.display = "block";
                });
            });

            // Close Modal
            document.querySelector(".close").addEventListener("click", function() {
                document.getElementById("updateModal").style.display = "none";
            });
        });
    </script>
</body>
</html>
