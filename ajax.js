

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
        console.log("change");
	    	prevRed[r].style.color = "black";
        //prevRed[r].setAttribute("name","textC");
	    }  
      for(r = 0; r< prevRed.length;r++){
        console.log("22222");
        prevRed[r].setAttribute("name","textC");
      }  

			//console.log(JSON.stringify(text));
	    for(i = 0; i< text.red.length;i++){
	      console.log("PRODUCT");
				document.getElementById(text.red[i].product).style.color =  "red";
				document.getElementById(text.red[i].cell).style.color =  "red";

        document.getElementById(text.red[i].product).setAttribute("name","changed");
        document.getElementById(text.red[i].cell).setAttribute("name","changed");

	    }
	    for(i = 0; i< text.redState.length;i++){
	      console.log("STATE");
				document.getElementById(text.redState[i].state_id).style.color =  "red";
        document.getElementById(text.redState[i].state_id).setAttribute("name","changed");
				
	    }

      /* =========================== TEXT ============================ */  
      var txt = "";
	    for(i = 0; i< text.message.length;i++){
	    	txt += text.message[i].productID + "|" +text.message[i].new_amount + "<br>";
	    }
      document.getElementById("message").innerHTML = txt;

      /* =========================== PURPLE ============================ */
      var prevPurple = document.getElementsByClassName("purpleColumn");

      //for(r = 0; r< prevPurple.length;r++){
        //console.log("purple");
        //prevPurple[r].style.backgroundColor = "white";
      //}  

      for(r = 0; r< prevPurple.length;r++){
        console.log("444444");
        //var originClassName = document.getElementById(prevPurple[r]).getAtrribute("id");
        //document.getElementById(prevPurple[r]).className = originClassName;
        //document.getElementsByClassName(originClassName).style.backgroundColor="red";;
      }  

      for(i = 0; i< text.purple.length;i++){

        var y = document.getElementsByClassName(text.purple[i].productId);

        for(var j = 0; j < y.length; j++){
          y[j].style.backgroundColor = "purple";

          if(y[j].id == y[j].className){
            y[j].className = "purpleColumn";
          }
        }

      }

	  }
  };
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}

