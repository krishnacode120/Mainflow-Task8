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
    <title>Manage Products</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="products.css">
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
        input, button {
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
        <h2>💡 Add a New Product</h2>
        <form action="ProductServlet" method="post">
            <input type="hidden" name="action" value="add">
            <input type="text" name="name" class="form-control" placeholder="Product Name" required><br>
            <input type="number" name="price" class="form-control" placeholder="Price" required><br>
            <input type="number" name="stock" class="form-control" placeholder="Stock Quantity" required><br>
            <button type="submit" class="btn btn-primary">Add Product</button>
        </form>

        <h3 class="mt-4">📦 Product List</h3>
        <table class="table table-dark table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
                        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products");
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td>₹<%= rs.getDouble("price") %></td>
                    <td><%= rs.getInt("stock") %></td>
                    <td>
                        <!-- Update Button -->
                        <button class="btn btn-warning btn-sm update-btn" 
                                data-id="<%= rs.getInt("id") %>" 
                                data-name="<%= rs.getString("name") %>" 
                                data-price="<%= rs.getDouble("price") %>" 
                                data-stock="<%= rs.getInt("stock") %>">
                            ✏ Update
                        </button>
                        
                        <!-- Delete Button -->
                        <a href="ProductServlet?action=delete&id=<%= rs.getInt("id") %>" 
                           class="btn btn-danger btn-sm">🗑 Delete</a>
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

    <!-- Update Product Modal -->
    <div id="updateModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Update Product</h3>
            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="update-id">
                <input type="text" name="name" id="update-name" class="form-control" placeholder="Product Name" required><br>
                <input type="number" name="price" id="update-price" class="form-control" placeholder="Price" required><br>
                <input type="number" name="stock" id="update-stock" class="form-control" placeholder="Stock Quantity" required><br>
                <button type="submit" class="btn btn-primary">Update Product</button>
            </form>
        </div>
    </div>

    <script>
        // Handle Update Button Click
        document.querySelectorAll(".update-btn").forEach(button => {
            button.addEventListener("click", function() {
                document.getElementById("update-id").value = this.dataset.id;
                document.getElementById("update-name").value = this.dataset.name;
                document.getElementById("update-price").value = this.dataset.price;
                document.getElementById("update-stock").value = this.dataset.stock;
                document.getElementById("updateModal").style.display = "block";
            });
        });

        // Close Modal
        document.querySelector(".close").addEventListener("click", function() {
            document.getElementById("updateModal").style.display = "none";
        });
    </script>
</body>
</html>
