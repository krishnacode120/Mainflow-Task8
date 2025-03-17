<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=Please login first");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Management System</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css">
</head>
<body class="theme-futuristic">
    
    <!-- Logout Button in the Corner -->
    <a href="logout.jsp" class="btn btn-danger logout-btn">Logout</a>

    <div class="container text-center mt-5">
        <h1 class="page-title">Billing Management System</h1>

        <div class="row mt-5">
            <div class="col-md-4">
                <a href="customers.jsp" class="btn btn-theme btn-lg">Manage Customers</a>
            </div>
            <div class="col-md-4">
                <a href="products.jsp" class="btn btn-theme btn-lg">Manage Products</a>
            </div>
            <div class="col-md-4">
                <a href="invoices.jsp" class="btn btn-theme btn-lg">Manage Invoices</a>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-4">
                <a href="payments.jsp" class="btn btn-theme btn-lg">Manage Payments</a>
            </div>
            <div class="col-md-4">
                <a href="reports.jsp" class="btn btn-theme btn-lg">View Reports</a>
            </div>
        </div>
    </div>

    <!-- Smooth Page Transition Effect -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.body.classList.add("fade-in");
        });
    </script>

</body>
</html>
