<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="orders.css">
<script language="javascript" src="ajax.js"></script> 
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
	Statement stmt3 = conn.createStatement();
	Statement stmt4 = conn.createStatement();
	Statement stmt5 = conn.createStatement();
	Statement stmt6 = conn.createStatement();

	ResultSet rs_top50_products = null;
	ResultSet rs_top50_states = null;
	PreparedStatement cell_amount = null;
	String categoryOption = "";

	
	ResultSet rs_categories = stmt2.executeQuery("select name from categories");
	

	int numOfOrders = 0;

	/* =========================== Category Option ============================== */
	if ("POST".equalsIgnoreCase(request.getMethod())) {
	  if( request.getParameter("category_option") == null){
      categoryOption = (String)session.getAttribute("category_option");
      if(categoryOption==null){
	      session.setAttribute("category_option","all");
	      categoryOption = "all";
	    }
    }
    else{
      categoryOption = request.getParameter("category_option");
      session.setAttribute("category_option", categoryOption);
    }
    /* =========================== Insert Orders ============================== */
		String action = request.getParameter("submit");
		if (action.equals("insert")) {
			ResultSet rs_numOrders = stmt5.executeQuery("select max(id) from orders");
			//get number of orders before insertion
			if(rs_numOrders.next()){
				numOfOrders = Integer.parseInt(rs_numOrders.getString("max"));
			}
			int queries_num = Integer.parseInt(request.getParameter("queries_num"));
			Random rand = new Random();
			int random_num = rand.nextInt(30) + 1;
			if (queries_num < random_num) 
				random_num = queries_num;
			
			stmt.executeQuery("SELECT proc_insert_orders(" + queries_num + "," + random_num + ")");
			out.println("<script>alert('" + queries_num + " orders are inserted!');</script>");

			ResultSet added_sale = 
				stmt4.executeQuery(
					"select state_id,product_id,round(cast(sum(o.price) as numeric),2) as amount "+ 
					"from (select * from orders offset "+
					numOfOrders+")o join users u on u.id = o.user_id "+ 
					"join products p on p.id = o.product_id "+
					"group by state_id, product_id "+
					"order by state_id ASC, product_id;");

			while(added_sale!=null&&added_sale.next()){
				int state = added_sale.getInt("state_id");
				int product = added_sale.getInt("product_id");
				int amount = added_sale.getInt("amount");
				stmt5.executeUpdate("insert into logTable(state_id,product_id,amount) "+
				"values("+state+","+product+","+amount+");");		
			}

		}
		/* =========================== Run ============================== */
		else if (action.equals("run")) {
			ResultSet logEntry = stmt5.executeQuery("select * from logTable");

			while(logEntry.next()){
				int state = logEntry.getInt("state_id");
				int product = logEntry.getInt("product_id");
				int amount = logEntry.getInt("amount");
				
				int result = 0;
				result = stmt6.executeUpdate(
					"update state_product set amount = amount + " + amount +
					" where state_id = " + state + "and product_id = " + product +";"
					);
				if(result == 0){
					stmt6.executeUpdate(
						"insert into state_product(state_id,product_id,amount) values ("+
						state+","+product+","+amount+");");
				}
			}

			stmt5.executeUpdate("delete from logTable");

			if(categoryOption.equals("all")){
				rs_top50_products = stmt3.executeQuery(
				"select p.id, p.name, u.amount from (" +
				"select product_id, round(cast(sum(amount) as numeric), 2) as amount " +
				"from state_product " +
				"group by product_id " +
				"order by amount DESC limit 50)u join " +
				"products p on u.product_id = p.id order by u.amount;");
			}
			else{
				rs_top50_products = stmt3.executeQuery(
				"select p.id, p.name, u.amount from (" +
				"select product_id, round(cast(sum(amount) as numeric), 2) as amount " +
				"from state_product " +
				"where product_id in (select id from products where "+
				"category_id =(select id from categories where name ="+
				"\'" +categoryOption + "\'"+ ")) "+
				"group by product_id " +
				"order by amount DESC limit 50) u join " +
				"products p on u.product_id = p.id order by u.amount;");
			}

			rs_top50_states = stmt.executeQuery(
				"select s.name, s.id,u.amount from ("+
				"select state_id, round(cast(sum(amount) as numeric), 2)  as amount "+
				"from state_product "+
				"group by state_id order by amount DESC) u join states s "+ 
				"on u.state_id = s.id order by u.amount DESC;");

			cell_amount = conn.prepareStatement(
		    "select coalesce(round(cast(sum(amount) as numeric), 2),0)  as amount from state_product where product_id=? and state_id=?"); 
    }
	}%>

<body>
<div class="collapse navbar-collapse">
	<ul class="nav navbar-nav">
		<li><a href="index.jsp">Home</a></li>
		<li><a href="categories.jsp">Categories</a></li>
		<li><a href="products.jsp">Products</a></li>
		<li><a href="orders.jsp">Orders</a></li>
		<li><a href="login.jsp">Logout</a></li>
	</ul>
</div>
<div>
<form action="orders.jsp" method="POST">
	<label># of queries to insert</label>
	<input type="number" name="queries_num">
	<input class="btn btn-primary"  type="submit" name="submit" value="insert"/>
</form>

<form action="orders.jsp" method="POST">
	<select name = "category_option" >
      <option value = "all">All</option>
      <%while(rs_categories != null && rs_categories.next()){
          String category = rs_categories.getString("name");
          if(categoryOption != "" && categoryOption.equals(category)) {%>
            <option selected value="<%=category%>"><%=category%></option>
          <%}
          else{%>
            <option value="<%=category%>"><%=category%></option>
          <%}
        }%>
    </select>
	<input class="btn btn-success"  type="submit" name="submit" value="run"/>
</form>

<button class="btn btn-success refresh" onclick = "refresh()">Refresh</button>
<button class="btn btn-success endRefresh" onclick = "refresh()">Refresh</button>

<table class="table table-striped"><%
	if(rs_top50_products != null && rs_top50_states != null && cell_amount != null){ %>
    <th>State | Product</th>
    <%
    /* =============== Display Top-50 Products Header ===================*/
      ArrayList productList = new ArrayList(); 
      while(rs_top50_products.next()){
        String productSpending = 
            ((rs_top50_products.getString("amount") == null) ? "0" : 
            rs_top50_products.getString("amount"));
        %>
        <th><%=rs_top50_products.getString("name") + " (" + productSpending + ")"%></th>
        <%productList.add(rs_top50_products.getString("id"));   
      }
    /* =============== Display Top-50 States Header ===================*/
      ResultSet salesAmount = null;
      while(rs_top50_states.next()){%>
        <tr>
          <%String amount = 
            ((rs_top50_states.getString("amount") == null) ? "0" : 
            rs_top50_states.getString("amount"));%>
          <td><b><%=rs_top50_states.getString("name")+ " ("+
            amount+")"%></b></td><%
     		/* =============== Display Top-50 States Header ===================*/
        for(int counter = 0; counter < productList.size(); counter++){
            cell_amount.setInt(1, Integer.valueOf((String)productList.get(counter)));
            cell_amount.setInt(2, Integer.valueOf(rs_top50_states.getString("id")));
            salesAmount = cell_amount.executeQuery();
            if (salesAmount!= null && salesAmount.next()){ %>
              <td><%= "$ " + salesAmount.getString("amount") %></td>  
            <%}
            else {%>
              <td><%= "$ 0 "%></td>
            <%}
        }%></tr><%
      }
    }
 %>
</table>

<button class="btn btn-success refresh" onclick = "refresh()">Refresh</button>
<button class="btn btn-success endRefresh" onclick = "refresh()">Refresh</button>
</form>
</body>
</html>