import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InvoiceServlet")
public class InvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String customerId = request.getParameter("customer_id");
        String productId = request.getParameter("product_id");
        String quantity = request.getParameter("quantity");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BillingManagement", "root", "krishna@12");

            // Insert into invoices table
            String invoiceSQL = "INSERT INTO invoices (customer_id, total_amount, date) VALUES (?, ?, NOW())";
            PreparedStatement invoiceStmt = conn.prepareStatement(invoiceSQL, PreparedStatement.RETURN_GENERATED_KEYS);
            invoiceStmt.setInt(1, Integer.parseInt(customerId));
            invoiceStmt.setDouble(2, 0.0);  // Initial amount, updated later
            invoiceStmt.executeUpdate();
            
            // Get invoice ID
            java.sql.ResultSet rs = invoiceStmt.getGeneratedKeys();
            int invoiceId = 0;
            if (rs.next()) {
                invoiceId = rs.getInt(1);
            }
            
            // Get product price
            String priceSQL = "SELECT price FROM products WHERE id = ?";
            PreparedStatement priceStmt = conn.prepareStatement(priceSQL);
            priceStmt.setInt(1, Integer.parseInt(productId));
            java.sql.ResultSet priceRs = priceStmt.executeQuery();
            double price = 0.0;
            if (priceRs.next()) {
                price = priceRs.getDouble("price");
            }
            
            // Calculate total price
            double totalPrice = price * Integer.parseInt(quantity);

            // Insert into invoice_items table
            String itemSQL = "INSERT INTO invoice_items (invoice_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSQL);
            itemStmt.setInt(1, invoiceId);
            itemStmt.setInt(2, Integer.parseInt(productId));
            itemStmt.setInt(3, Integer.parseInt(quantity));
            itemStmt.setDouble(4, totalPrice);
            itemStmt.executeUpdate();

            // Update total amount in invoices table
            String updateInvoiceSQL = "UPDATE invoices SET total_amount = ? WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateInvoiceSQL);
            updateStmt.setDouble(1, totalPrice);
            updateStmt.setInt(2, invoiceId);
            updateStmt.executeUpdate();

            // Close connections
            invoiceStmt.close();
            priceStmt.close();
            itemStmt.close();
            updateStmt.close();
            conn.close();

            response.sendRedirect("invoices.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
