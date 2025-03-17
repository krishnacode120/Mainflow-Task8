<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Billing Management System - Login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <div class="container">
        <h1 class="title">Billing Management System</h1>
        <h2>🔐 User Login</h2>
        <form action="AuthServlet" method="post">
            <input type="hidden" name="action" value="login">
            <input type="text" name="username" class="form-control" placeholder="Username" required><br>
            <input type="password" name="password" class="form-control" placeholder="Password" required><br>
            <button type="submit" class="btn btn-primary">Login</button>
        </form>
        <p class="mt-3">Don't have an account?  
            <a href="register.jsp" class="transition-link">Register</a>
        </p>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.body.style.opacity = "1";
        });

        document.querySelectorAll(".transition-link").forEach(link => {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                let targetUrl = this.href;
                document.body.style.animation = "fadeOut 0.4s ease-in forwards";
                setTimeout(() => {
                    window.location.href = targetUrl;
                }, 400);
            });
        });
    </script>
</body>
</html>
