
var xmlHttp = new XMLHttpRequest();
function refresh(){

  xmlHttp.onreadystatechange = stateChanged;
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}
function stateChanged(){
  if (xmlHttp.readyState==4) {
    var i;
    var xmlDoc=xmlHttp.responseXML;
    var productRed = xmlDoc.getElementsByTagName("CD");
    for(i = 0; i < productRed.length;i++){
      document.getElementById("testing").innerHTML = 
      productRed[i].getElementsByTagName("ARTIST")[0].childNodes[0].nodeValue;//.style.color = "red";
    }
    //document.getElementById("")
    //var = xmlDoc.getElementsByTagName("product")[0].nodeValue;
    //document.getElementById("testing").innerHTML = xmlHttp.responseText;
    //document.getElementById("SRkb4UaJKc").color = "#FF0000";
    //$("th").css("background-color", "#FF0000");

  }
}
