<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Grade Report</title>
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

          ResultSet rs = statement.executeQuery("SELECT DISTINCT s.SSN FROM student s, period_attend p WHERE p.student_ssn = s.SSN" );
      %>

          <form action="gradereport.jsp" method="get">
	          <input type="hidden" value="choose" name="action">
              <select name="SSN">
      <%
      	        while(rs.next()){
      %>
      	            <option><%=rs.getInt("SSN")%></option>
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

      		    <!-- Display students -->
      	      <table border="1">
      		      <tr>
        		      <caption>Selected Student Info</caption>
        		      <th>Student SSN</th>
     		          <th>First Name</th>
     		          <th>Middle Name</th>
     		          <th>Last Name</th>
      		      </tr>
      <%
      		      statement = conn.createStatement();
      		      int SSN = Integer.parseInt(request.getParameter("SSN"));
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

      <% 
              SSN = Integer.parseInt(request.getParameter("SSN"));
      %>

              <!-- Display classes taken by student X -->
              <table border="1">
                <tr>
                  <caption>Classes Taken By Selected Student</caption>
                  <th>Course Number</th>
                  <th>Title</th>
                  <th>Currently Teaching</th>
                  <th>Next Offered Quarter</th>
                  <th>Next Offered Year</th>
                  <th>Quarter</th>
                  <th>Year</th>
                  <th>Grade</th>
                  <th>Units</th>
                </tr>
      <%
                statement = conn.createStatement();
                rs = statement.executeQuery("SELECT c.course_number, c.title, c.currently_taught, c.quarter_next, c.year_next, h.quarter, h.year, h.grade, h.unit FROM class c, have_taken h WHERE student_ssn = " + SSN + " AND c.course_number = h.course_number ORDER BY h.quarter, h.year DESC");
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet
                while ( rs.next() ) {
      %>
                    <tr>
                      <td><%= rs.getString("course_number") %></td>
                      <td><%= rs.getString("title") %></td>
                      <td><%= rs.getBoolean("currently_taught") %></td>
                      <td><%= rs.getString("quarter_next") %></td>
                      <td><%= rs.getInt("year_next") %></td>
                      <td><%= rs.getString("quarter") %></td>
                      <td><%= rs.getInt("year") %></td>
                      <td><%= rs.getString("grade") %></td>
                      <td><%= rs.getInt("unit") %></td>
                    </tr>
      <%
                } 
      %>
              </table>


              <!-- Display Grade Report of student X -->
              <table border="1">
                <tr>
                  <caption>Grade Report of Selected Student</caption>
                  <th>Quarter</th>
                  <th>Year</th>
                  <th>Term GPA</th>
                </tr>


      <%

                create table GRADE_CONVERSION (LETTER_GRADE CHAR(2) NOT NULL, NUMBER_GRADE DECIMAL(2,1));
                insert into grade_conversion values('A+', 4.3);
                insert into grade_conversion values('A', 4);
                insert into grade_conversion values('A-', 3.7);
                insert into grade_conversion values('B+', 3.4);
                insert into grade_conversion values('B', 3.1);
                insert into grade_conversion values('B-', 2.8);
                insert into grade_conversion values('C+', 2.5);
                insert into grade_conversion values('C', 2.2);
                insert into grade_conversion values('C-', 1.9);
                insert into grade_conversion values('D', 1.6); 

                Statement stmt = conn.createStatement();

                rs = stmt.executeQuery("SELECT h.quarter, h.year, SUM(h.unit *h. g.NUMBER_GRADE)/SUM(h.unit) AS termgpa, SUM(h.unit) AS totalunits, SUM(h.unit * g.NUMBER_GRADE) AS totalgrade FROM have_taken h, GRADE_CONVERSION g WHERE h.student_ssn = " + SSN + " AND h.grade = g.LETTER_GRADE AND h.grade <> 'IN' AND grade_opition <> 'S/U' GROUP BY h.quarter, h.year ORDER BY h.quarter, h.year DESC");
                  

                <%-- -------- Iteration Code -------- --%>
      <%
        	      // Iterate over the ResultSet
       		      while ( rs.next() ) {
      %>
      		          <tr>
          		        <th><%=rs.getString("quarter")%></th>
                      <th><%=rs.getInt("year")%></th>
                      <th><%=rs.getDouble("termgpa")%></th>       
      			       </tr>
      <%
      		      }
                double totalunits = <%=rs.getDouble("totalunits")%>
                double totalgrade = <%=rs.getDouble("totalgrade")%>
                double CumulativeGPA = totalgrade/totalunits;

      %>
                </table>

                <p>Cumulative GPA</p>

      <%
                out.println(CumulativeGPA);
      %>          

              
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
