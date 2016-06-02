

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

	    for(i = 0; i< text.message.length;i++){
	    	//document.getElementById(text[0].).style.color = "red";

	    	//document.getElementById(text[0].redNode[1]).style.color = "red";

	    	//document.getElementById(text[0].redNode[2]);
	    	document.getElementById("testing").innerHTML = "YEAH123";
	    	document.getElementById("message").innerHTML = "YE" + text.message[i].productID;

				//document.getElementById(text.message[i].productID).style.color =  "red";
				//document.getElementById(text.message[i].new_amount).style.color =  "red";

	    }




	  }

  };
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}

