<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Billing Management System - Register</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="register.css">
</head>
<body>
    <div class="container">
        <h1 class="title">Billing Management System</h1>
        <h2>📝 Register</h2>
        <form action="AuthServlet" method="post">
            <input type="hidden" name="action" value="register">
            <input type="text" name="username" class="form-control" placeholder="Username" required><br>
            <input type="password" name="password" class="form-control" placeholder="Password" required><br>
            <select name="role" class="form-control">
                <option value="admin">Admin</option>
                <option value="staff">Staff</option>
            </select><br>
            <button type="submit" class="btn btn-primary">Register</button>
        </form>
        <p class="mt-3">Already have an account?  
            <a href="login.jsp" class="transition-link">Login</a>
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
