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
                            "postgres", "admin123");

            %>
            <%-- -------- Insertion Code -------- --%>
            <%
            // Check if an insertion is requested
            String action = request.getParameter("action"); 
            if (action != null && action.equals("insert")) {

                conn.setAutoCommit(false);

                // Create the prepared statement and use it to 
                // INSERT the enrolled attrs INTO the enrolled table. 
                PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO reserved VALUES (?, ?, ?, ?,?)"));

                pstmt.setString(1, request.getParameter("LOTID")); 
                pstmt.setString(2, request.getParameter("FACULTYNAME"));
                pstmt.setString(3, request.getParameter("SPACEID"));
                pstmt.setString(4, request.getParameter("DATESTART"));
                pstmt.setString(5, request.getParameter("DATEEND"));


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
                // UPDATE the reserved attributes in the reserved table. 
                PreparedStatement pstatement = conn.prepareStatement( 
                    "UPDATE reserved SET faculty_name = ?, date_start = ?, date_end = ?" + 
                    "WHERE lot_id = ?, space_id = ?");
                    pstatement.setString(1, request.getParameter("FACULTYNAME"));
                    pstatement.setString(2, request.getParameter("DATESTART"));
                    pstatement.setString(3, request.getParameter("DATEEND")); 
                    pstatement.setInt(4, request.getParameter("LOTID")); 
                    pstatement.setInt(5, request.getParameter("SPACEID"));

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
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM reserved WHERE lot_id = ?, space_id = ?");

                        pstmt.setString(1, request.getParameter("LOTID"));
                        pstmt.setString(2, request.getParameter("SPACEID"));

                
                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);

                    }

            %>

            <%-- -------- Statement Code -------- --%>
            <%
            // Create the statement
            Statement statement = conn.createStatement();

            ResultSet rs = statement.executeQuery("SELECT * FROM reserved");
            %>

            <%-- -------- Presentation Code -------- --%>
            <table>
               <tr>
                 <th>LOTID</th>
                 <th>FACULTYNAME</th>
                 <th>SPACEID</th>
                 <th>DATESTART</th>
                 <th>DATEEND</th>
                 </tr>


            <%-- -------- Insert From Code -------- --%>
            <tr>
              <form action="parking_lot.jsp" method="get">
                <input type="hidden" value="insert" name="action">
                <th><input value="" name="LOTID" size="10"></th>
                <th><input value="" name="FACULTYNAME" size="10"></th>
                <th><input value="" name="SPACEID" size="10"></th>
                <th><input value="" name="DATESTART" size="10"></th>
                <th><input value="" name="DATEEND" size="10"></th>
                <th><input type="submit" value="insert"></th>
              </form>
            </tr>


            <%
               //Iterate over the ResultSet
               while( rs.next() ){
            %>

            <%-- -------- Iteration Code -------- --%>
              <tr>
                <form action="reserved.jsp" method="get">
                    <input type="hidden" value="update" name="action">
                    <td><input value="<%= rs.getString("lot_id")%>" name ="LOTID"></td>
                    <td><input value="<%= rs.getString("faculty_name")%>" name="NAME"></td>
                    <td><input value="<%= rs.getString("space_id")%>" name="SPACEID"></td>
                    <td><input value="<%= rs.getString("date_start")%>" name="DATE_START"></td>
                    <td><input value="<%= rs.getString("date_end")%>" name="DATE_END"></td>
                    <td><input type="submit" value="Update"></td> 
                </form>
                </form action="reserved.jsp" method="get">
                    <input type="hidden" value="delete" name="action"> 
                    <input type="hidden" value="<%= rs.getString("lot_id")%>" name ="LOTID">
                    <input type="hidden" value="<%= rs.getString("space_id")%>" name ="SPACEID">>
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