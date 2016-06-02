<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>CSE135 Project</title>
</head>

<% 
  Connection conn = null;
  try {
     Class.forName("org.postgresql.Driver");
     String url = "jdbc:postgresql:cse135";
     String admin = "postgres";
     String password = "";
     conn = DriverManager.getConnection(url, admin, password);
  }
  catch (Exception e) {}

  Statement stmt = conn.createStatement();
  Statement stmt2 = conn.createStatement();

  ResultSet logEntry = stmt.executeQuery("select distinct product_id from logTable "+
    "where product_id in (select product_id from top_50_products)");
  while(logEntry.next()){
    int product = logEntry.getInt("product_id");%>
    <%=product%>
  <%}
%>

<body>
</body>
</html>