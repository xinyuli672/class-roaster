<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Students currently enrolled in classes in Spring 2018</title>
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

          // Use the created statement to SELECT students who are currently enrolled 
          ResultSet rs = statement.executeQuery("SELECT DISTINCT s.SSN FROM student s, enrolled e WHERE e.student_ssn = s.SSN" );
      %>

          <form action="currentlyenrolled.jsp" method="get">
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

      		    <!-- Add an HTML table header row to format the results -->
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

              Statement stmt = conn.createStatement();
              rs = stmt.executeQuery("SELECT c.title, c.course_number, c.quarter_next, c.year_next, e.section_number, e.unit FROM student s, enrolled e, section sec, class c WHERE s.SSN = " + SSN + " AND c.course_number = sec.course_number AND sec.section_number = e.section_number AND e.student_ssn = s.SSN");
      %>

              <table border="1">
                <tr>
                  <caption>Spring 2018 Enrolled Classes Report of Selected Student</caption>
                  <th>Course Title</th>
                  <th>Course Number</th>
                  <th>Next Offered In Quarter</th>
                  <th>Next Offered In Year</th>
                  <th>Section Number</th>
                  <th>Unit</th>
                </tr>

                <%-- -------- Iteration Code -------- --%>
      <%
        	      // Iterate over the ResultSet
       		      while ( rs.next() ) {
      %>
      		          <tr>
          		        <th><%=rs.getString("title")%></th>
                      <th><%=rs.getString("course_number")%></th>
                      <th><%=rs.getString("quarter_next")%></th>
                      <th><%=rs.getInt("year_next")%></th>
                      <th><%=rs.getString("section_number")%></th>
          		        <th><%=rs.getInt("unit")%></th>       
      			       </tr>
      <%
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
