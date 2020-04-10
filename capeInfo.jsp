<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Decision Support(Cape Review)</title>
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


      <table border="1">
      <tr>
        <caption>3.a.ii. using Materialized View<caption>
        <th>Course Number</th>
        <th>Professor</th>
        <th>Quarter</th>
        <th>Year</th>
      </tr>

      <tr>
        <form action="capeInfo.jsp" method="get">
          <input type="hidden" value="insert1" name="action">
          <th><input value="" name="CNUMBER" size="25"></th>
          <th><input value="" name="PROF" size="25"></th>
          <th><input value="" name="QUARTER" size="25"></th>
          <th><input value="" name="YEAR" size="25"></th>
          <th><input type="submit" value="Choose"></th>
        </form>
      </tr>
      </table>

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

      <%
        String action = request.getParameter("action");
        if (action != null && action.equals("insert1")) {
          conn.setAutoCommit(false);

          String course = request.getParameter("CNUMBER");
          String prof = request.getParameter("PROF");
          String quarter = request.getParameter("QUARTER");
          String year = request.getParameter("YEAR");

          Statement stmt = conn.createStatement();
          ResultSet rsA = stmt.executeQuery("SELECT SUM(number) as sumA FROM CPQG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND quarter = '" + quarter + "' AND year = " + year + " AND grade = 'A'");
          rsA.next();
          int gradeA = rsA.getInt("sumA");

          stmt = conn.createStatement();
          ResultSet rsB = stmt.executeQuery("SELECT SUM(number) AS sumB FROM CPQG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND quarter = '" + quarter + "' AND year = " + year + " AND grade = 'B'");
          rsB.next();
          int gradeB = rsB.getInt("sumB");

          stmt = conn.createStatement();
          ResultSet rsC = stmt.executeQuery("SELECT SUM(number) AS sumC FROM CPQG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND quarter = '" + quarter + "' AND year = " + year + " AND grade = 'C'");
          rsC.next();
          int gradeC = rsC.getInt("sumC");

          stmt = conn.createStatement();
          ResultSet rsD = stmt.executeQuery("SELECT SUM(number) AS sumD FROM CPQG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND quarter = '" + quarter + "' AND year = " + year + " AND grade = 'D'");
          rsD.next();
          int gradeD = rsD.getInt("sumD");

          stmt = conn.createStatement();
          ResultSet rsTotal = stmt.executeQuery("SELECT SUM(number) AS sumall FROM CPQG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND quarter = '" + quarter + "' AND year = " + year);
          rsTotal.next();
          int gradeOther = rsTotal.getInt("sumall") - gradeA - gradeB - gradeC - gradeD;

          conn.commit();
          conn.setAutoCommit(true);
      %>

      <table border="1" width="400">
      <tr>
        <caption>Grades Received</caption>
        <th>A</th>
        <th>B</th>
        <th>C</th>
        <th>D</th>
        <th>Other</th>
      </tr>
      <tr>
        <td><%= gradeA %></td>
        <td><%= gradeB %></td>
        <td><%= gradeC %></td>
        <td><%= gradeD %></td>
        <td><%= gradeOther %></td>
      </tr>
      </table>

      <%
        }
      %>

      <table border="1">
      <tr>
        <caption>3.a.iii. using Materialized View<caption>
        <th>Course Number</th>
        <th>Professor</th>
      </tr>

      <tr>
        <form action="capeInfo.jsp" method="get">
          <input type="hidden" value="insert2" name="action">
          <th><input value="" name="CNUMBER" size="25"></th>
          <th><input value="" name="PROF" size="25"></th>
          <th><input type="submit" value="Choose"></th>
        </form>
      </tr>
      </table>

      <%
        if (action != null && action.equals("insert2")) {
          conn.setAutoCommit(false);

          String course = request.getParameter("CNUMBER");
          String prof = request.getParameter("PROF");

          Statement stmt = conn.createStatement();
          ResultSet rsA = stmt.executeQuery("SELECT SUM(number) AS gradesumA FROM CPG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND grade = 'A'");
          rsA.next();
          int gradeA = rsA.getInt("gradesumA");

          stmt = conn.createStatement();
          ResultSet rsB = stmt.executeQuery("SELECT SUM(number) AS gradesumB FROM CPG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND grade = 'B'");
          rsB.next();
          int gradeB = rsB.getInt("gradesumB");

          stmt = conn.createStatement();
          ResultSet rsC = stmt.executeQuery("SELECT SUM(number) AS gradesumC FROM CPG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND grade = 'C'");
          rsC.next();
          int gradeC = rsC.getInt("gradesumC");

          stmt = conn.createStatement();
          ResultSet rsD = stmt.executeQuery("SELECT SUM(number) AS gradesumD FROM CPG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "' AND grade = 'D'");
          rsD.next();
          int gradeD = rsD.getInt("gradesumD");

          stmt = conn.createStatement();
          ResultSet rsTotal = stmt.executeQuery("SELECT SUM(number) AS gradesumAll FROM CPG WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "'");
          rsTotal.next();
          int gradeOther = rsTotal.getInt("gradesumAll") - gradeA - gradeB - gradeC - gradeD;

          conn.commit();
          conn.setAutoCommit(true);
      %>

      <table border="1" width="400">
      <tr>
        <caption>Grades Received</caption>
        <th>A</th>
        <th>B</th>
        <th>C</th>
        <th>D</th>
        <th>Other</th>
      </tr>
      <tr>
        <td><%= gradeA %></td>
        <td><%= gradeB %></td>
        <td><%= gradeC %></td>
        <td><%= gradeD %></td>
        <td><%= gradeOther %></td>
      </tr>
      </table>

      <%
        }
      %>

      <table border="1">
      <tr>
        <caption>3.a.iv.<caption>
        <th>Course Number</th>
      </tr>

      <tr>
        <form action="capeInfo.jsp" method="get">
          <input type="hidden" value="insert3" name="action">
          <th><input value="" name="CNUMBER" size="25"></th>
          <th><input type="submit" value="Choose"></th>
        </form>
      </tr>
      </table>

      <%
        if (action != null && action.equals("insert3")) {
          conn.setAutoCommit(false);

          String course = request.getParameter("CNUMBER");
          String prof = request.getParameter("PROF");

          Statement stmt = conn.createStatement();
          ResultSet rsA = stmt.executeQuery("SELECT COUNT(*) FROM have_taken natural join have_taught WHERE course_number = '" + course + "' AND grade like 'A%'");
          rsA.next();
          int gradeA = rsA.getInt("count");

          stmt = conn.createStatement();
          ResultSet rsB = stmt.executeQuery("SELECT COUNT(*) FROM have_taken natural join have_taught WHERE course_number = '" + course + "' AND grade like 'B%'");
          rsB.next();
          int gradeB = rsB.getInt("count");

          stmt = conn.createStatement();
          ResultSet rsC = stmt.executeQuery("SELECT COUNT(*) FROM have_taken natural join have_taught WHERE course_number = '" + course + "' AND grade like 'C%'");
          rsC.next();
          int gradeC = rsC.getInt("count");

          stmt = conn.createStatement();
          ResultSet rsD = stmt.executeQuery("SELECT COUNT(*) FROM have_taken natural join have_taught WHERE course_number = '" + course + "' AND grade like 'D%'");
          rsD.next();
          int gradeD = rsD.getInt("count");

          stmt = conn.createStatement();
          ResultSet rsTotal = stmt.executeQuery("SELECT COUNT(*) FROM have_taken natural join have_taught WHERE course_number = '" + course + "'");
          rsTotal.next();
          int gradeOther = rsTotal.getInt("count") - gradeA - gradeB - gradeC - gradeD;

          conn.commit();
          conn.setAutoCommit(true);
      %>

      <table border="1" width="400">
      <tr>
        <caption>Grades Received</caption>
        <th>A</th>
        <th>B</th>
        <th>C</th>
        <th>D</th>
        <th>Other</th>
      </tr>
      <tr>
        <td><%= gradeA %></td>
        <td><%= gradeB %></td>
        <td><%= gradeC %></td>
        <td><%= gradeD %></td>
        <td><%= gradeOther %></td>
      </tr>
      </table>

      <%
        }
      %>

      <table border="1">
      <tr>
        <caption>3.a.v.<caption>
        <th>Course Number</th>
        <th>Professor</th>
      </tr>

      <tr>
        <form action="capeInfo.jsp" method="get">
          <input type="hidden" value="insert4" name="action">
          <th><input value="" name="CNUMBER" size="25"></th>
          <th><input value="" name="PROF" size="25"></th>
          <th><input type="submit" value="Choose"></th>
        </form>
      </tr>
      </table>

      <%
        if (action != null && action.equals("insert4")) {
          conn.setAutoCommit(false);

          String course = request.getParameter("CNUMBER");
          String prof = request.getParameter("PROF");

          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT * FROM have_taken LEFT JOIN grade_conversion ON grade = letter_grade NATURAL JOIN have_taught WHERE course_number = '" + course + "' AND faculty_name = '" + prof + "'");

          int count = 0;
          double total = 0.0;

          while(rs.next()){
            total += rs.getDouble("number_grade");
            count++;
          }

          double average = total / count;

          conn.commit();
          conn.setAutoCommit(true);
      %>

      <p>Grade Point Average is <%= average %></p>

      <%
        }
      %>


      <%-- -------- Close Connection Code -------- --%>
      <%

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






