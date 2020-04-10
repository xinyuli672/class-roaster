<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Class Roaster</title>
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

          ResultSet rs = statement.executeQuery("SELECT DISTINCT c.title FROM classes c, section sec WHERE c.course_number = sec.course_number AND sec.quarter = "SPRING" AND sec.year = "2018"" );
          %>

          <form action="classroaster.jsp" method="get">
	          <input type="hidden" value="submit" name="action">
              <select name="title">

      	  <%
      	        while(rs.next()){
      	  %>
      	          <option><%=rs.getString("title")></option>
          <%
                }
      	  %>
              </select> 
            <input type="submit" value="submit">
          </form>


          <%
          String action = request.getParameter("action");

          if (action != null && request.getParameter("action").equals("submit")){
          

              conn.setAutoCommit(false);
          %>
              <!-- Add an HTML table header row to format the results -->
              <table border="1">
                <tr>
                  <caption>Selected Class</caption>
                  <th>Course Number</th>
                  <th>Title</th>
                  <th>Quater</th>
                  <th>Year</th>
                </tr>

      <%
                statement = conn.createStatement();
                String title = request.getParameter("title");
                rs = statement.executeQuery(("SELECT c.course_number AS courseNum, c.title, sec.quarter, sec.year FROM class c, section sec WHERE c.course_number = sec.course_number AND c.title = " + title));
      %>

                <%-- -------- Iteration Code -------- --%>
      <%
                // Iterate over the ResultSet
                while ( rs.next() ) {
      %>
                <tr>
                    <td><%= rs.getString("courseNum") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("quarter") %></td>
                    <td><%= rs.getInt("year") %></td>
                </tr>
      <%
                } //closes while loop
      %>
              </table>

      <%

            

                Statement stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT s.SSN, s.student_id, s.firstname, s.middlename, s.lastname, s.residency, e.grade_option, e.unit FROM student s, classes c, section sec, enrolled e WHERE c.title = " +title + " AND sec.course_number = c.course_number AND e.section_number = sec.section_number AND e.student_ssn = s.SSN");
      %>

                <table border="1">
      	          <caption>All Students Enrolled In This Class</caption>
                  <tr>
                    <th>SSN</th>
                    <th>Student Id</th>
                    <th>First Name</th>
                    <th>Middle Name</th>
                    <th>Last Name</th>
                    <th>Residensy</th>
                    <th>Grade Option</th>
                    <th>Unit</th>
                  </tr>

                  <%-- -------- Iteration Code -------- --%>
      <%
                  // Iterate over the ResultSet
                  while ( rs.next() ) {
      %>
                    <tr>
                      <th><%=rs.getInt("SSN")%></th>
                      <th><%=rs.getString("studnet_id")%></th>
                      <th><%=rs.getString("firstname")%></th>
                      <th><%=rs.getString("middlename")%></th>
                      <th><%=rs.getString("lastname")%></th>
                      <th><%=rs.getString("residency")%></th>
                      <th><%=rs.getString("grade_option")%></th>
                      <th><%=rs.getInt("unit")%></th>
                    </tr>
      <%
                  }//closes while loop
      %>

                </table>
      <%
              conn.commit();
              conn.setAutoCommit(true);
          } //closes if stmt
      %>

          <%-- -------- Close Connection Code -------- --%>
      <%
          // Close the ResultSet
          rs.close();

          // Close the Statement
          statement.close();
          stmt.close();

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
