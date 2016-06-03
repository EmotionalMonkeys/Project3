function refresh(){
	var xmlHttp = new XMLHttpRequest();

  xmlHttp.onreadystatechange = function(){
  	if (xmlHttp.readyState==4 && xmlHttp.status == 200) {
	    var i,j,w;
	    var x = xmlHttp.responseText;

	    var text = JSON.parse(x);
	    /*
	    var white = document.getElementsByName("textC");
	    for(w = 0; w< white.length;i++){
	    	white[w].style.color = "black";
	    }
	    */


			console.log(JSON.stringify(text));

			//display red color changes 
	    for(i = 0; i< text.red.length;i++){
				document.getElementById(text.red[i].product).style.color =  "red";

				document.getElementById(text.red[i].product).innerHTML =  
					(text.red[i].name +" (" + text.red[i].amount + ")");
				document.getElementById(text.red[i].cell).style.color =  "red";

	    }

	    //display state changes 
	    for(i = 0; i< text.redState.length;i++){
				document.getElementById(text.redState[i].state_id).style.color =  "red";
				document.getElementById(text.redState[i].state_id).innerHTML =  
					(text.redState[i].stateName + " (" + text.redState[i].stateAmount + ")");
	    }


      var txt = "";
      if(text.message.length!= 0){
      	txt += "You need to <Strong> refresh </Strong> to update the current Top 50 Products </br><hr>";
      }
	    for(i = 0; i< text.message.length;i++){
	    	txt += "Product: <b>\'" + text.message[i].productName + "\'</b> with amount of <b> $ " +
	    	        text.message[i].new_amount + " </b>becomes New Top 50 Products</br>";

	    }


      document.getElementById("message").innerHTML = txt;

      for(i = 0; i< text.purple.length;i++){

        //document.getElementBy(text.purple[i].productId).style.color =  "purple";

        var y = document.getElementsByClassName(text.purple[i].productId);

        for(var j = 0; j< y.length; j++){
          y[j].style.backgroundColor = "purple";
        }

      }
	  }

  };
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}

