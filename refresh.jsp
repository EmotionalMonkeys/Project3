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

  //Top-50 products in table that are updated 
  ResultSet productToChange = stmt.executeQuery("select distinct product_id from logTable "+
    "where product_id in (select product_id from top_50_products)");
  while(productToChange.next()){
    int product = productToChange.getInt("product_id");%>
    <product><name><%=product%></name></product>
  <%}
  //Top-50 states in table that are updated 
  ResultSet statesToChange = stmt.executeQuery("select distinct state_id from logTable;");
  while(statesToChange.next()){
    int state = statesToChange.getInt("state_id");%>
    <state><name><%=state%></name></state>
  <%}


  ResultSet logEntry = stmt.executeQuery("select * from logTable");
  while(logEntry.next()){
        int state = logEntry.getInt("state_id");
        int product = logEntry.getInt("product_id");
        int amount = logEntry.getInt("amount");
        
        int result = 0;
        result = stmt2.executeUpdate(
          "update state_product set amount = amount + " + amount +
          " where state_id = " + state + "and product_id = " + product +";"
          );
        if(result == 0){
          stmt2.executeUpdate(
            "insert into state_product(state_id,product_id,amount) values ("+
            state+","+product+","+amount+");");
        }
      }

  stmt.executeUpdate("delete from logTable");
%>

<body>
</body>
</html>