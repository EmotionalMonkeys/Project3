<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<title>CSE135 Project</title>
</head>
<%
	Connection conn = null;
	String categoryOption = "";
	


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
	
	ResultSet rs_categories = stmt2.executeQuery("select name from categories");
	ResultSet rs_numOrders = stmt3.executeQuery("select count(*) from orders");

	int numOfOrders = 0;
	//get number of orders
	if(rs_numOrders.next()){
		numOfOrders = Integer.parseInt(rs_numOrders.getString("count"));
	}

	//get number of orders since last refresh/run
	String total_orders = (String)application.getAttribute("total_orders");

	//first time accessing the website
	if(total_orders==null){
		application.setAttribute("total_orders",new Integer(numOfOrders).toString());
	}
	//new sales added
	else if(numOfOrders > Integer.parseInt(total_orders)) {
		ResultSet added_sale = 
		stmt4.executeQuery("select * from orders offset "+Integer.parseInt(total_orders)+";");

		while(added_sale.next()){
			//stmt4.executeQuery("insert into added_sale values()");
			%>
			<p><%=added_sale.getString("product_id")%></p>
		<%}
	}

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
		String action = request.getParameter("submit");
		if (action.equals("insert")) {
			int queries_num = Integer.parseInt(request.getParameter("queries_num"));
			Random rand = new Random();
			int random_num = rand.nextInt(30) + 1;
			if (queries_num < random_num) 
				random_num = queries_num;
			
			stmt.executeQuery("SELECT proc_insert_orders(" + queries_num + "," + random_num + ")");
			out.println("<script>alert('" + queries_num + " orders are inserted!');</script>");
		}
		else if (action.equals("refresh")) {
			//Need to implement.
		}
		else if (action.equals("run")) {
			
		}
	}
	
%>

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
	<input class="btn btn-success"  type="submit" name="submit" value="refresh"/>
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




</body>
</html>