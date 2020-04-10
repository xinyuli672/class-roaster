<html>

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
                try {
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:sqlserver://om.ucsd.edu:1433;databaseName=cse132b", 
                            "admin", "admin");

            %>
            <%-- -------- Insertion Code -------- --%>
            <%
            // Check if an insertion is requested
            String action = request.getParameter("action"); 
            if (action != null && action.equals("insert")) {

                conn.setAutoCommit(false);

                // Create the prepared statement and use it to 
                // INSERT the enrolled attrs INTO the enrolled table. 
                PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO have_taken VALUES (?, ?, ?, ?)"));

                pstmt.setString(1, request.getParameter("student_id"))); 
                pstmt.setString(2, request.getParameter("section_id"));
                pstmt.setString(3, request.getParameter("grade"));
                pstmt.setInt(4, Boolean.parseBoolean(request.getParameter("incomplete")));

                pstmt.executeUpdate();

                // Commit transaction
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
                    "UPDATE have_taken SET grade = ?, incomplete = ?" + 
                    "WHERE student_id = ?, section_id = ?");
                    pstatement.setString(1, request.getParameter("grade"));
                    pstatement.setInt(2, Boolean.parseBoolean(request.getParameter("incomplete")));
                    pstatement.setString(3, request.getParameter("student_id")); 
                    pstatement.setString(4, request.getParameter("section_id")); 


                    int rowCount = pstatement.executeUpdate();

                    conn.setAutoCommit(false);
                    conn.setAutoCommit(true);

            %>


                    <%-- -------- Delete Code -------- --%>
                    <%
                    // Check if a delete is requested 
                    if (action != null && action.equals("delete")) {

                        conn.setAutoCommit(false);

                        // Create the prepared statement and use it to 
                        // DELETE the enrolled FROM the enrolled table. 
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM have_taken WHERE student_id = ?, section_id = ?");

                        pstmt.setString(1, request.getParameter("student_id"));
                        pstmt.setString(2, request.getParameter("section_id"));
                
                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);

                    }

            %>

            <%-- -------- Statement Code -------- --%>
            <%
            // Create the statement
            Statement statement = conn.createStatement();

            ResultSet rs = statement.executeQuery("SELECT * FROM have_taken");
            %>

            <%-- -------- Presentation Code -------- --%>
            <table>
               <tr>
                 <th>student_id</th>
                 <th>section_id</th>
                 <th>grade</th>
                 <th>incomplete</th>
                 </tr>


            <%-- -------- Insert From Code -------- --%>
            <tr>
              <form action="have_taken.jsp" method="get">
                <input type="hidden" value="insert" name="action">
                <th><input value="" name="student_id" size="10"></th>
                <th><input value="" name="section_id" size="10"></th>
                <th><input value="" name="grade" size="10"></th>
                <th><input value="" name="incomplete" size="10"></th>
                <th><input type="submit" value="insert"></th>
              </form>
            </tr>


            <%
               //Iterate over the ResultSet
               while( rs.next() ){
            %>

            <%-- -------- Iteration Code -------- --%>
              <tr>
                <form action="have_taken.jsp" method="get">
                    <input type="hidden" value="update" name="action">
                    <%-- Get the student_id--%>
                    <td><input value="<%= rs.getString("student_id")%>" name ="student_id"></td>
                    <%-- Get the section_id--%>
                    <td><input value="<%= rs.getString("section_id")%>" name="section_id>"</td>
                    <%-- Get the grade--%>
                    <td><input value="<%= rs.getString("grade")%>" name="grade"></td>
                    <%-- Get the unit--%>
                    <td><input value="<%= rs.getBoolean("incomplete")%>" name="incomplete"></td>
                    <td><input type="submit" value="Update"></td> 
                </form>
                </form action="have_taken.jsp" method="get">
                    <input type="hidden" value="delete" name="action"> 
                    <input type="hidden" value="<%= rs.getString("student_id")%>" name ="student_id">
                    <input type="hidden" value="<%= rs.getString("section_id")%>" name="section_id">
                    <input type="hidden" value="<%= rs.getBoolean("incomplete")%>" name="incomplete">
                    <td><input type="submit" value="Delete"></td> 

              </tr>

            <%
               }
            %>
</table>


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
                </table>
            </td>
        </tr>
    </table>
</body>

</html>