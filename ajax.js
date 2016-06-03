function refresh(){
	var xmlHttp = new XMLHttpRequest();

  xmlHttp.onreadystatechange = function(){
  	if (xmlHttp.readyState==4 && xmlHttp.status == 200) {
	    var i,j,r;
	    var x = xmlHttp.responseText;

	    var text = JSON.parse(x);
	    /* =========================== RED ============================ */    
	    var prevRed = document.getElementsByName("changed");
	    for(r = 0; r< prevRed.length;r++){
       
	    	prevRed[r].style.color = "black";
	    }  
      for(r = 0; r< prevRed.length;r++){
        
        prevRed[r].setAttribute("name","textC");
      }  

	    for(i = 0; i< text.red.length;i++){
	     

				document.getElementById(text.red[i].product).style.color =  "red";

				document.getElementById(text.red[i].product).innerHTML =  
					(text.red[i].name +" (" + text.red[i].amount + ")");
				document.getElementById(text.red[i].cell).style.color =  "red";

        document.getElementById(text.red[i].product).setAttribute("name","changed");
        document.getElementById(text.red[i].cell).setAttribute("name","changed");

	    }

	    //display state changes 
	    for(i = 0; i< text.redState.length;i++){
	      
				document.getElementById(text.redState[i].state_id).style.color =  "red";
        document.getElementById(text.redState[i].state_id).setAttribute("name","changed");
				
				document.getElementById(text.redState[i].state_id).innerHTML =  
					(text.redState[i].stateName + " (" + text.redState[i].stateAmount + ")");
	    }

      /* =========================== TEXT ============================ */  
      var txt = "";
      document.getElementById("message").innerHTML = "";
      if(text.message.length!= 0){
      	txt += "You need to <Strong> refresh </Strong> to update the current Top 50 Products </br><hr>";
      }
	    for(i = 0; i< text.message.length;i++){

	    	txt += "Product: <b>\'" + text.message[i].productName + "\'</b> with amount of <b> $ " +
	    	        text.message[i].new_amount + " </b>becomes New Top 50 Products</br>";

	    }

      document.getElementById("message").innerHTML = txt;

      /* =========================== PURPLE ============================ */
      var prevPurple = document.getElementsByClassName("purpleColumn");
     
      for(r = 0; r< prevPurple.length;r++){
        var t = prevPurple[r].id;
       
        prevPurple[r].className = t;
        var temp = document.getElementsByClassName(t);
        
        for(i = 0; i< temp.length;i++){
          temp[i].style.backgroundColor="transparent";
        }
        
      }  

      for(i = 0; i< text.purple.length;i++){

        var y = document.getElementsByClassName(text.purple[i].productId);

        for(var j = 0; j < y.length; j++){
          y[j].style.backgroundColor = "purple";
          if(y[j].className == y[j].getAttribute("id")){
            
            y[j].className = "purpleColumn";
            y[j].style.backgroundColor = "purple";
          }
        }

      }

	  }
  };
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}

