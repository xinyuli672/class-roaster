<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Remaining Degree Requirement For Graduate Students</title>
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
          ResultSet rs = statement.executeQuery("SELECT DISTINCT g.student_ssn FROM enrolled e, graduate g WHERE e.student_ssn = g.student_ssn ORDER BY g.student_ssn ASC" );
          statement = conn.createStatement();
          ResultSet rs1 = statement.executeQuery("SELECT DISTINCT degree_name FROM degree WHERE degree_type = 'M.S.'");
      %>

          <form action="remainingdegreereqGrad.jsp" method="get">
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

      <%
              //statement = conn.createStatement();
              //ResultSet rs2 = statement.executeQuery("SELECT degree_type FROM degree WHERE degree_name = '"+ degreename +"' AND degree_type = 'M.S.'");
              
      %>


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
                rs = statement.executeQuery("SELECT degree_name, degree_type FROM degree WHERE degree_name = '" + degreename +"' AND degree_type = 'M.S.'");
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



              <!-- display concentrations completed -->
              <table border="1">
                <tr>
                  <caption>Concentrations Completed</caption>
                  <th>Concentration Name</th>
                </tr>
      <%
                //display concentrations completed
                //check the units taken for per concentration, unitstaken >= min_unit req'd
                //check the gpa for courses count toward concentration, gap >= min_gpa req'd
                //ignore classes with IN grade and s/u (check grade_option) for gpa
                //ignore classes with IN for unit
                statement = conn.createStatement();
                rs = statement.executeQuery("SELECT * FROM concentration WHERE degree_name = '"+ degreename+ "' AND degree_type = 'M.S.'");
                
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet
                
                while ( rs.next() ) {
                    int unitrequired = 0;
                    double gparequired = 0.00;
                    int unitstaken = 0;
                    double gpa = 0.00;
                    int gpaunit = 0;

                    unitrequired = rs.getInt("min_unit");
                    gparequired = rs.getDouble("min_gpa");
                    String concentrationname = rs.getString("concentration_name");

                    statement = conn.createStatement();
                    rs1 = statement.executeQuery("SELECT * FROM concentration_course NATURAL JOIN have_taken JOIN grade_conversion ON grade=letter_grade WHERE concentration_name = '"+ concentrationname + "' AND student_ssn = " + SSN + " AND grade_option <> 'S/U'");

                    while(rs1.next()){
                        unitstaken += rs1.getInt("unit");
                        String grade = rs1.getString("grade");
                        if(! grade.equals("IN")){
                            gpaunit += rs1.getInt("unit");
                            gpa += rs1.getDouble("number_grade")* rs1.getInt("unit");
                        }
                        %>
 
<%
                    }

                    if(gpaunit !=0){
                        gpa = gpa / gpaunit;
                    }
%>
<tr>
<td><%=concentrationname%></td>

<td><%=gpa%></td>
<td><%=unitstaken%></td>
                        </tr>
 
<%


                    if ( unitstaken >= unitrequired && gpa >= gparequired ){
      %>
                        <tr>
                            <td><%=concentrationname%></td>
                        </tr>
      <%
                    }
                } 
      %>
              </table>




              <!-- display courses needed for each concentration in selected degree-->
              <table border="1">
                <tr>
                  <caption>Courses Needed For Each Concentration In Selected Degree</caption>
                  <th>Concentration Name</th>
                  <th>Course Number</th>
                  <th>Title</th>
                  <th>Currently Teaching</th>
                  <th>Next Offered In Quarter</th>
                  <th>Next Offered In Year</th>
                </tr>
      <%
                
                statement = conn.createStatement();
                //rs: courses in every concentraion in selected degree the selected student has not taken yet. 
                rs = statement.executeQuery("SELECT * FROM concentration WHERE degree_name = '"+ degreename + "' AND degree_type = 'M.S.'");
                //rs = statement.executeQuery("SELECT con.concentration_name, c.course_number, c.title, c.currently_taught, c.quarter_next, c.year_next FROM class c, concentration con, concentration_course cc WHERE con.degree_name = '" + degreename +"' AND con.degree_type = 'M.S.' AND cc.concentration_name = cc.course_number AND c.course_number = cc.course_number AND NOT EXISTS (SELECT * FROM have_taken h WHERE h.student_ssn = "+ SSN + ") GROUP BY con.concentration_name c.course_number");
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet

                while ( rs.next() ) {
                    String concentrationname = rs.getString("concentration_name");
                    statement = conn.createStatement();
                    rs1 = statement.executeQuery("SELECT * FROM concentration_course con JOIN class c ON con.course_number=c.course_number WHERE con.concentration_name = '"+ concentrationname+"' AND con.course_number NOT IN (SELECT h.course_number FROM have_taken h WHERE h.student_ssn = "+SSN+" AND h.grade ='F')");

                    while(rs1.next()) {
      %>
                        <tr>
                    	    <td><%=concentrationname%></td>
                    	    <td><%=rs1.getString("course_number")%></td>
                    	    <td><%=rs1.getString("title")%></td>
                    	    <td><%=rs1.getBoolean("currently_taught")%></td>
                    	    <td><%=rs1.getString("quarter_next")%></td>
                    	    <td><%=rs1.getInt("year_next")%></td>
                        </tr>
      <%
                    }
                    
                }
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
