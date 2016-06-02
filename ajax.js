

function refresh(){
	var xmlHttp = new XMLHttpRequest();

  xmlHttp.onreadystatechange = function(){
  	if (xmlHttp.readyState==4 && xmlHttp.status == 200) {
	    var i,j;
	    var x = xmlHttp.responseText;

	    var text = JSON.parse(x);


	    for(i = 0; i< text.red.length;i++){
	    	//document.getElementById(text[0].).style.color = "red";

	    	//document.getElementById(text[0].redNode[1]).style.color = "red";

	    	//document.getElementById(text[0].redNode[2]);
				document.getElementById(text.red[i].product).style.color =  "red";
				document.getElementById(text.red[i].cell).style.color =  "red";

	    }
      var txt = "";
	    for(i = 0; i< text.message.length;i++){
	    	//document.getElementById(text[0].).style.color = "red";

	    	//document.getElementById(text[0].redNode[1]).style.color = "red";

	    	//document.getElementById(text[0].redNode[2]);
	    	//document.getElementById("testing").innerHTML = "YEAH123";
	    	txt +=
        text.message[i].productID + "|" +text.message[i].new_amount + "<br>";

				//document.getElementById(text.message[i].productID).style.color =  "red";
				//document.getElementById(text.message[i].new_amount).style.color =  "red";

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

