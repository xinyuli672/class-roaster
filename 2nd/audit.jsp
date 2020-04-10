<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Degree Audit</title>
</head>

<body>
  <table border="1">
    <tr>
      <td valign="top">
        <%-- -------- Include menu HTML code -------- --%>
        <jsp:include page="menu.html" />
      </td>
      <td>

      <%-- Set the scripting language to Java and --%>
      <%-- Import the java.sql package --%>
      <%@ page language="java" import="java.sql.*" %>

      <%-- -------- Open Connection Code -------- --%>
      <%
        Connection conn = null;

        try {
          Class.forName("org.postgresql.Driver");

          String dbURL = "jdbc:postgresql://localhost/cse132";
          String user = "postgres";
          String pass = "admin123";
          conn = DriverManager.getConnection(dbURL, user, pass);
      %>

      <%-- -------- Insertion Code -------- --%>
      <%
        // Check if an insertion is requested
        String action = request.getParameter("action");
        if (action != null && action.equals("insert")) {
          conn.setAutoCommit(false);

          // Create the prepared statement and use it to
          // INSERT the audit attrs INTO the audit table.
          PreparedStatement pstmt = conn.prepareStatement
            ("INSERT INTO audit VALUES (?, ?, ?, ?)");

          pstmt.setString(1, request.getParameter("SID"));
          pstmt.setString(2, Integer.parseInt(request.getParameter("DID")));
          pstmt.setString(3, request.getParameter("CURRENTUNIT"));
          pstmt.setString(4, Boolean.parseBoolean(request.getParameter("STATUS")));

          pstmt.executeUpdate();

          conn.commit();
          conn.setAutoCommit(true);
        }
      %>



      <%-- -------- Update Code -------- --%>
      <%
      // Check if an update is requested
      if (action != null && action.equals("update")) {

          conn.setAutoCommit(false);

          // Create the prepared statement and use it to
          // UPDATE the audit attributes in the audit table. 
          PreparedStatement pstatement = conn.prepareStatement( 
              "UPDATE audit SET current_unit = ?, status = ? WHERE student_id = ? AND degree_id = ?");
              pstatement.setString(1, request.getParameter("CURRENTUNIT"));
              pstatement.setString(2, Boolean.parseBoolean(request.getParameter("STATUS"))); 
              pstatement.setString(3, request.getParameter("SID")); 
              pstatement.setString(4, Integer.parseInt(request.getParameter("DID")));


              int rowCount = pstatement.executeUpdate();

              conn.setAutoCommit(false);
              conn.setAutoCommit(true);

      %>

      <%-- -------- Delete Code -------- --%>
      <%
        // Check if a delete is requested
        if (action != null && action.equals("delete")) {

          // Begin transaction
          conn.setAutoCommit(false);

          // Create the prepared statement and use it to
          // DELETE the period_attend FROM the period_attend table.
          PreparedStatement pstmt = conn.prepareStatement(
            "DELETE FROM audit WHERE studnet_id = ? AND degree_id = ?");

          pstmt.setString(1, request.getParameter("SID"));
          pstmt.setString(2, request.getParameter("DID"));

          pstmt.executeUpdate();

          // Commit transaction
          conn.commit();
          conn.setAutoCommit(true);
        }
      %>


      <%-- -------- SELECT Statement Code -------- --%>
      <%
        // Create the statement
        Statement statement = conn.createStatement();

        // Use the created statement to SELECT
        // the probation attributes FROM the probation table.
        ResultSet rs = statement.executeQuery("SELECT * FROM audit");
      %>

      <!-- Add an HTML table header row to format the results -->
      <table border="1">
      <tr>
        <th>Student ID</th>
        <th>Degree ID</th>
        <th>Current Unit Earned</th>
        <th>Status</th>
        <th>Action</th>
      </tr>

      <%-- -------- Insert Form Code -------- --%>
      <tr>
        <form action="audit.jsp" method="get">
          <input type="hidden" value="insert" name="action">
          <th><input value="" name="SID" size="15"></th>
          <th><input value="" name="DID" size="30"></th>
          <th><input value="" name="CURRENTUNIT" size="30"></th>
          <th><input value="" name="STATUS" size="30"></th>
          <th><input type="submit" value="Insert"></th>
        </form>
      </tr>


      <%-- -------- Iteration Code -------- --%>
      <%
        // Iterate over the ResultSet

        while ( rs.next() ) {

      %>


      <tr>
        <form action="audit.jsp" method="get">
          <input type="hidden" value="update" name="action">
          <td><input value="<%= rs.getString("student_id") %>" name="SID" size="15"></td>

          <td><input value="<%= rs.getInt("degree_id") %>" name="DID" size="30"></td>

          <td><input value="<%= rs.getString("current_unit") %>" name="CURRENTUNIT" size="30"></td>

          <td><input value="<%= rs.getBoolean("status")%>" name="STATUS"></td>

          <td><input type="submit" value="Update"></td>
        </form>

        <form action="audit.jsp" method="get">
          <input type="hidden" value="delete" name="action">
          <input type="hidden" value="<%= rs.getString("student_id") %>" name="SID">
          <input type="hidden" value="<%= rs.getInt("degree_id") %>" name="DID">
          <td><input type="submit" value="Delete"></td>
        </form>
      </tr>

      <%
        }
      %>

      <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          rs.close();

          // Close the Statement
          statement.close();

          // Close the Connection
          conn.close();

        } catch (SQLException sqle) {
          out.println(sqle.getMessage());
        } catch (Exception e) {
          out.println(e.getMessage());
      }
      %>

      </td>
    </tr>
  </table>
</body>

</html>
