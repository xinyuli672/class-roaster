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
                PreparedStatement pstmt = conn.prepareStatement( ("INSERT INTO parking_lot VALUES (?, ?, ?, ?)"));

                pstmt.setString(1, request.getParameter("LOTID"))); 
                pstmt.setString(2, request.getParameter("NAME"));
                pstmt.setString(3, Integer.parseInt(request.getParameter("RESERVATIONLIMIT")));
                pstmt.setString(4, request.getParameter("LOCATION"));
s
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
                    "UPDATE parking_lot SET name = ?, reservation_limit = ?, location = ?" + 
                    "WHERE lot_id = ?");
                    pstatement.setString(1, request.getParameter("NAME"));
                    pstatement.setInt(2, Integer.parseInt(request.getParameter("RESERVATIONLIMIT")));
                    pstatement.setString(3, request.getParameter("LOCATION")); 
                    pstatement.setString(4, request.getParameter("LOTID")); 


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
                        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM parking_lot WHERE lot_id = ?");

                        pstmt.setString(1, request.getParameter("LOTID"));

                
                        int rowCount = pstmt.executeUpdate();

                        conn.setAutoCommit(false);
                        conn.setAutoCommit(true);

                    }

            %>

            <%-- -------- Statement Code -------- --%>
            <%
            // Create the statement
            Statement statement = conn.createStatement();

            ResultSet rs = statement.executeQuery("SELECT * FROM parking_lot");
            %>

            <%-- -------- Presentation Code -------- --%>
            <table>
               <tr>
                 <th>LOTID</th>
                 <th>NAME</th>
                 <th>RESERVATIONLIMIT</th>
                 <th>LOCATION</th>
                 </tr>


            <%-- -------- Insert From Code -------- --%>
            <tr>
              <form action="parking_lot.jsp" method="get">
                <input type="hidden" value="insert" name="action">
                <th><input value="" name="LOTID" size="10"></th>
                <th><input value="" name="NAME" size="10"></th>
                <th><input value="" name="RESERVATIONLIMIT" size="10"></th>
                <th><input value="" name="LOCATION" size="10"></th>
                <th><input type="submit" value="insert"></th>
              </form>
            </tr>


            <%
               //Iterate over the ResultSet
               while( rs.next() ){
            %>

            <%-- -------- Iteration Code -------- --%>
              <tr>
                <form action="parking_lot.jsp" method="get">
                    <input type="hidden" value="update" name="action">
                    <%-- Get the student_id--%>
                    <td><input value="<%= rs.getString("lot_id")%>" name ="LOTID"></td>
                    <td><input value="<%= rs.getString("name")%>" name="NAME"></td>
                    <%-- Get the section_id--%>
                    <td><input value="<%= rs.getString("reservation_limit")%>" name="RESERVATIONLIMIT"></td>
                    <%-- Get the grading--%>
                    <td><input value="<%= rs.getString("location")%>" name="LOCATION"></td>
                    <%-- Get the unit--%>
                    <td><input type="submit" value="Update"></td> 
                </form>
                </form action="parking_lot.jsp" method="get">
                    <input type="hidden" value="delete" name="action"> 
                    <input type="hidden" value="<%= rs.getString("lot_id")%>" name ="LOTID">
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