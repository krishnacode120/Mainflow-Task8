<%
    if (session != null) {
        session.invalidate();  // Destroy session
    }
    response.sendRedirect("login.jsp?message=Logged out successfully");
%>
