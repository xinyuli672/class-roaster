<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Remaining Degree Requirement For Undergraduate Students</title>
  <style>
    table, th, td {
       border: 1px solid black;
    }
  </style>
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


          <%-- -------- SELECT Statement Code -------- --%>
      <%
          // Create the statement
          Statement statement = conn.createStatement();

          ResultSet rs = statement.executeQuery("SELECT DISTINCT u.student_ssn FROM enrolled e, undergraduate u WHERE e.student_ssn = u.student_ssn" );
          statement = conn.createStatement();
          ResultSet rs1 = statement.executeQuery("SELECT DISTINCT degree_name FROM degree WHERE degree_type <> 'M.S.'");
      %>

          <form action="remainingdegreereq.jsp" method="get">
            <input type="hidden" value="choose" name="action">
              <select name="SSN">
      <%
                while(rs.next()){
      %>
                    <option><%=rs.getInt("student_ssn")%></option>
      <%
                }
      %>
              </select> 

              <select name="degreename">
      <%
                while(rs1.next()){
      %>
                    <option><%=rs1.getString("degree_name")%></option>
      <%
                }
            
      %>
              </select>


            <input type="submit" value="choose">
          </form>


      <%
          String action = request.getParameter("action");

      
          if (action != null && request.getParameter("action").equals("choose")){
          
              conn.setAutoCommit(false);
      %>

              <!-- display student -->
              <table border="1">
                <tr>
                  <caption>Selected Student Info</caption>
                  <th>Student SSN</th>
                  <th>First Name</th>
                  <th>Middle Name</th>
                  <th>Last Name</th>
                </tr>
      <%
                String degreename = request.getParameter("degreename");
                int SSN = Integer.parseInt(request.getParameter("SSN"));
                statement = conn.createStatement();
                rs = statement.executeQuery("SELECT SSN, firstname, middlename, lastname FROM student WHERE SSN = " + SSN);
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet
                while ( rs.next() ) {
      %>
                    <tr>
                      <td><%= rs.getInt("SSN") %></td>
                      <td><%= rs.getString("firstname") %></td>
                      <td><%= rs.getString("middlename") %></td>
                      <td><%= rs.getString("lastname") %></td>
                    </tr>
      <%
                } 
      %>
              </table>

              <!-- display degree -->
              <table border="1">
                <tr>
                  <caption>Selected Degree</caption>
                  <th>Degree Name</th>
                  <th>Degree Type</th>
                </tr>
      <%
                statement = conn.createStatement();
                rs = statement.executeQuery("SELECT DISTINCT degree_name, degree_type FROM degree g WHERE degree_name = " + degreename +" AND degree_type <> 'M.S.'");
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet
                while ( rs.next() ) {
      %>
                    <tr>
                      <td><%= rs.getString("degree_name") %></td>
                      <td><%= rs.getString("degree_type") %></td>
                    </tr>
      <%
                } 
      %>
              </table>


              <!-- display units needed -->
              <table border="1">
                <tr>
                  <caption>Units Needed For Selected Degree</caption>
                  <th>Total Units</th>
                  <th>Lower Division Unit</th>
                  <th>Upper Division Unit</th>
                  <th>Technical Elevtive Unit</th>
                </tr>
      <%
                //rs2= statement.executeQuery("CREATE VIEW ");

                statement = conn.createStatement();
                //rs: total units required by this degree
                rs = statement.executeQuery("SELECT g.total_unit, g.lower_unit, g.upper_unit, g.tech_unit FROM degree g WHERE degree_name = " + degreename +" AND degree_type <> 'M.S.'");
                //rs1: total units completed
                statement = conn.createStatement();
                rs1 = statement.executeQuery("SELECT SUM(h.unit) AS total_completed FROM have_taken h WHERE h.student_ssn = " + SSN);
                //rs2: categorize courseNumber
                statement = conn.createStatement();
                ResultSet rs2 = statement.executeQuery("SELECT h.course_number, h.unit FROM have_taken h WHERE h.student_ssn = " + SSN);
                //rs3: total elective completed
                statement = conn.createStatement();
                ResultSet rs3 = statement.executeQuery("SELECT SUM(h.unit) AS elective_completed FROM have_taken h, technical_elective t WHERE t.course_id = h.course_number AND h.student_ssn = " + SSN);

      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet

                int ldc = 0;
                int udc = 0;


                while ( rs2.next() ) {
                    String courseNUM = rs2.getString("course_number");
                    String[] part = courseNUM.split("(?<=\\D)(?=\\d)");
                    String NumChar = part[1].substring(1);
                    char character = NumChar.charAt(0);
                    if ((int) character < 48 || (int) character > 57){
                        NumChar = part[1].substring(0,part[1].length()-1);

                    }
                    int Num = Integer.parseInt(NumChar);

                    if ( Num < 100 && Num >0 ) {
                        ldc = ldc + rs2.getInt("unit");
                    }else if (Num >99 && Num < 200){
                        udc = udc + rs2.getInt("unit");
                    }
                }

                int ld = rs.getInt("lower_unit");
                int ud = rs.getInt("upper_unit");
                int ldr = ld - ldc; //lower div remaining
                int udr = ud - udc; //upper div remainging
                int tc = rs1.getInt("total_completed");
                int t = rs.getInt("total_unit");
                int tr = t - tc; //total remaining
                int e = rs.getInt("tech_unit");
                int ec = rs3.getInt("elective_completed");
                int er = e - ec; //elective remaining
      %>
                <tr>
                    <td><%=tr%></td>
                    <td><%=ldr%></td>
                    <td><%=udr%></td>
                    <td><%=er%></td>
      %>

              </table>


      <%
              conn.commit();
              conn.setAutoCommit(true);

          } //closes if
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
