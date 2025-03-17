import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/BillingManagement";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "krishna@12";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addCustomer(request, response);
        } else if ("update".equals(action)) {
            updateCustomer(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        System.out.println("Received action: " + action); // Debug log

        if ("delete".equals(action)) {
            deleteCustomer(request, response);
        }
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO customers (name, email, phone) VALUES (?, ?, ?)")) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.executeUpdate();

            System.out.println("✅ Customer added successfully: " + name); // Debug log

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("customers.jsp");
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("customers.jsp?error=Invalid ID");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("UPDATE customers SET name=?, email=?, phone=? WHERE id=?")) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setInt(4, Integer.parseInt(idParam));
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                System.out.println("✅ Customer updated successfully: " + idParam); // Debug log
            } else {
                System.out.println("⚠ Customer update failed: ID " + idParam + " not found."); // Debug log
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect("customers.jsp");
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String idParam = request.getParameter("id");

    System.out.println("Delete request received. ID: " + idParam); // Debug log

    if (idParam == null || idParam.isEmpty()) {
        System.out.println("⚠ Error: Invalid ID received.");
        response.sendRedirect("customers.jsp?error=Invalid ID");
        return;
    }

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");
         PreparedStatement stmt = conn.prepareStatement("DELETE FROM customers WHERE id=?")) {

        int id = Integer.parseInt(idParam);
        stmt.setInt(1, id);
        int rowsDeleted = stmt.executeUpdate();

        if (rowsDeleted > 0) {
            System.out.println("✅ Customer with ID " + id + " deleted successfully."); // Debug log
        } else {
            System.out.println("⚠ Deletion failed: No customer with ID " + id + " found."); // Debug log
        }

    } catch (SQLException | NumberFormatException e) {
        e.printStackTrace();
    }

    response.sendRedirect("customers.jsp");
}
}
