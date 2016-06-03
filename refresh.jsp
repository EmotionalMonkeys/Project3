<%@ page contentType="text/html" import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray"%>

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
Statement stmt5 = conn.createStatement();
Statement stmt6 = conn.createStatement();

JSONObject change = new JSONObject();

JSONArray red = new JSONArray();
JSONArray redState = new JSONArray();
JSONArray message = new JSONArray();
JSONArray purple = new JSONArray();



/*=============== Top-50 products in table that are updated ==============*/
ResultSet turnRed = stmt.executeQuery(
	"select u.state_id, u.product_id, u.name, round(cast(u.amount as numeric),2) as amount from ( "+
	"select lt.state_id,lt.product_id, lt.name, (lt.amount + sp.amount) as amount "+
	"from (select lt.state_id,lt.product_id, p.name, lt.amount "+
	"      from logTable lt join products p on p.id = lt.product_id "+
	"      where lt.product_id in (select product_id from top_50_products)) lt "+
	"	join (select product_id, round(cast(sum(amount) as numeric), 2)  as amount "+
	"		from state_product "+
	"		where product_id in (select product_id from top_50_products) "+
	"		group by product_id) sp on lt.product_id = sp.product_id "+
	"group by lt.state_id, lt.product_id, lt.name, lt.amount, sp.amount)u ;");

while(turnRed.next()){
  String product = turnRed.getString("product_id");
  String state = "s"+turnRed.getString("state_id");
  String name = turnRed.getString("name");
  String amount = turnRed.getString("amount");
  String cell = product +"|" +state;

	JSONObject redNode = new JSONObject();

  redNode.put("product",product);
  redNode.put("cell",cell);
  redNode.put("name",name);
  redNode.put("amount",amount);
  red.put(redNode);

}

change.put("red",red);


ResultSet turnRedState = null;

turnRedState = stmt6.executeQuery(
	"select d.state_id, d.name, round(cast(d.amount as numeric),2) as amount from ("+
	"select lt.state_id, s.name, (lt.amount + k.amount) as amount "+
	"from logTable lt join states s on lt.state_id = s.id "+
	"join (select state_id, round(cast(sum(amount) as numeric), 2) as amount "+
	"from state_product group by state_id )k on lt.state_id = k.state_id)d ;" );

while(turnRedState.next()){
  String state_id = "s"+turnRedState.getString("state_id");
  String stateName = turnRedState.getString("name");
  String stateAmount = turnRedState.getString("amount");
  JSONObject redStateNode = new JSONObject();

  redStateNode.put("state_id",state_id);
  redStateNode.put("stateName",stateName);
  redStateNode.put("stateAmount",stateAmount);
  redState.put(redStateNode);

}
change.put("redState",redState);


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
productGotIn50 = stmt5.executeQuery(
"select u.product_id, p.name from "+
"(select product_id from new50 "+
"except select product_id "+
"from top_50_products)u join products p on u.product_id = p.id ;");

productTurnPurple = stmt4.executeQuery(
"select product_id "+
"from top_50_products "+
"except select * from new50;");

while(productGotIn50.next()){
  String productID = productGotIn50.getString("product_id");
  String productName = productGotIn50.getString("name");
  String new_amount = "0";
  ResultSet rs_amount = 
  stmt3.executeQuery("select round(cast(sum(amount) as numeric), 2) as sum "+
  "from state_product where product_id = "+productID+";");

  if(rs_amount.next())
    new_amount = rs_amount.getString("sum");

  JSONObject messageNode = new JSONObject();
  messageNode.put("productName",productName);
  messageNode.put("new_amount",new_amount);
  message.put(messageNode);

}
change.put("message",message);




while(productTurnPurple.next()){
  String productId = productTurnPurple.getString("product_id");
	JSONObject purpleNode = new JSONObject();
  purpleNode.put("productId",productId);
  purple.put(purpleNode);
}
change.put("purple",purple);

out.print(change);


stmt.executeUpdate("delete from logTable;");
  
%>



