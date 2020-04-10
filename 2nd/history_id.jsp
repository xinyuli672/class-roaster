<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Course ID History</title>
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
          // INSERT the probation attrs INTO the probation table.
          PreparedStatement pstmt = conn.prepareStatement
            ("INSERT INTO history_id VALUES (?, ?, ?)");

          pstmt.setString(1, request.getParameter("COURSEID"));
          pstmt.setString(2, request.getParameter("OLDID"));
          pstmt.setString(3, request.getParameter("UNTILYEAR"));

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
          // UPDATE the enrolled attributes in the enrolled table. 
          PreparedStatement pstatement = conn.prepareStatement( 
              "UPDATE history_id SET until_year = ? WHERE course_id = ? AND old_id = ?");
              pstatement.setString(1, request.getParameter("UNTILYEAR"));
              pstatement.setString(3, request.getParameter("COURSEID")); 
              pstatement.setString(3, request.getParameter("OLDID")); 


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
            "DELETE FROM history_id WHERE course_id = ? AND old_id = ?");

          pstmt.setString(1, request.getParameter("COURSEID"));
          pstmt.setString(2, request.getParameter("OLDID"));

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
        ResultSet rs = statement.executeQuery("SELECT * FROM history_id");
      %>

      <!-- Add an HTML table header row to format the results -->
      <table border="1">
      <tr>
        <th>COURSE ID</th>
        <th>Old Course ID</th>
        <th>Used until year</th>
        <th>Action</th>
      </tr>

      <%-- -------- Insert Form Code -------- --%>
      <tr>
        <form action="history_id.jsp" method="get">
          <input type="hidden" value="insert" name="action">
          <th><input value="" name="COURSEID" size="15"></th>
          <th><input value="" name="OLDID" size="30"></th>
          <th><input value="" name="UNTILYEAR" size="30"></th>
          <th><input type="submit" value="Insert"></th>
        </form>
      </tr>


      <%-- -------- Iteration Code -------- --%>
      <%
        // Iterate over the ResultSet

        while ( rs.next() ) {

      %>


      <tr>
        <form action="history_id.jsp" method="get">
          <input type="hidden" value="update" name="action">
          <td><input value="<%= rs.getString("course_id") %>" name="COURSEID" size="15"></td>

          <td><input value="<%= rs.getString("old_id") %>" name="OLDID" size="30"></td>

          <td><input value="<%= rs.getString("until_year") %>" name="UNTILYEAR" size="30"></td>

          <td><input type="submit" value="Update"></td>
        </form>

        <form action="history_id.jsp" method="get">
          <input type="hidden" value="delete" name="action">
          <input type="hidden" value="<%= rs.getString("course_id") %>" name="COURSEID">
          <input type="hidden" value="<%= rs.getString("old_id") %>" name="OLDID">
          <input type="hidden" value="<%= rs.getString("until_year") %>" name="UNTILYEAR">
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
