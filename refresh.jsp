<%@ page contentType="text/xml" %><?xml version="1.0" encoding="UTF-8"?>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<% response.setContentType("text/xml");%>
<CD>
  <TITLE>Empire Burlesque</TITLE>
  <ARTIST>Bob Dylan</ARTIST>
  <COUNTRY>USA</COUNTRY>
  <COMPANY>Columbia</COMPANY>
  <PRICE>10.90</PRICE>
  <YEAR>1985</YEAR>
</CD>
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
Statement stmt3 = conn.createStatement();
Statement stmt4 = conn.createStatement();

/*=============== Top-50 products in table that are updated ==============*/
ResultSet turnRed = stmt.executeQuery("select state_id,product_id from logTable "+
  "where product_id in (select product_id from top_50_products)");
%>
<Red> <%
while(turnRed.next()){
  String product = turnRed.getString("product_id");
  String state = "s"+turnRed.getString("state_id");
  String cell = product +"|" +state;
%>
  <productTurnRed><%=product%></productTurnRed>
  <stateTurnRed><%=state%></stateTurnRed>
  <cellTurnRed><%=cell%></cellTurnRed>
<%}

%>
</Red>
<%


/* ===================== Push logTable to Precomputed  Table ===================== */

//all row in log table 
ResultSet logEntry = stmt.executeQuery("select * from logTable");
while(logEntry.next()){
  int state = logEntry.getInt("state_id");
  int product = logEntry.getInt("product_id");
  int amount = logEntry.getInt("amount");
  
  int result = 0;
  //Update the sale amount if state/product pair is in the table
  result = stmt2.executeUpdate(
    "update state_product set amount = amount + " + amount +
    " where state_id = " + state + "and product_id = " + product +";"
    );
  //Insert the sale amount if state/product pair is not in the table
  if(result == 0){
    stmt2.executeUpdate(
      "insert into state_product(state_id,product_id,amount) values ("+
      state+","+product+","+amount+");");
  }
}
/* ======================== Product/Amount Message ===================== */
ResultSet productGotIn50 = null;
ResultSet productTurnPurple = null;
String categoryOption = (String)session.getAttribute("category_option");

stmt3.executeUpdate("drop view if exists new50;");

if(categoryOption.equals("all")){
  stmt3.executeUpdate(
  "create view new50 as "+
  "select product_id from "+
  "(select product_id, round(cast(sum(amount) as numeric), 2) as amount "+
  "from state_product "+
  "group by product_id "+
  "order by amount DESC limit 50)u;");
}
else{
  stmt3.executeUpdate(
  "create view new50 as "+
  "select product_id from "+
  "(select product_id, round(cast(sum(amount) as numeric), 2) as amount "+
  "from state_product "+
  "where product_id in (select id from products where "+
  "category_iprodd =(select id from categories where name ="+
  "\'" +categoryOption + "\'"+ ")) "+
  "group by product_id "+
  "order by amount DESC limit 50)u;");
}
productGotIn50 = stmt3.executeQuery(
"select * from new50 "+
"except select product_id "+
"from top_50_products;");

productTurnPurple = stmt4.executeQuery(
"select product_id "+
"from top_50_products "+
"except select * from new50;");

while(productGotIn50.next()){
  String productID = productGotIn50.getString("product_id");
  String new_amount = "0";
  ResultSet rs_amount = stmt3.executeQuery("select sum(amount) "+
  "from state_product where product_id = "+productID+";");

  if(rs_amount.next())
    new_amount = rs_amount.getString("sum");%>
  <productText><%=productID%></productText>
  <amountText><%=new_amount%></amountText>
<%}
while(productTurnPurple.next()){
  String productId = productTurnPurple.getString("product_id");
  %>
  <productTurnPurple><%=productId%></productTurnPurple>
<%}


stmt.executeUpdate("delete from logTable;");
  
%>

