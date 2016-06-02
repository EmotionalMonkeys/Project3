
var xmlHttp = new XMLHttpRequest();
function refresh(){

  xmlHttp.onreadystatechange = stateChanged;
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send();
}
function stateChanged(){
  if (xmlHttp.readyState==4) {
    var i;
    var xmlDoc=xmlHttp.responseXML;
    var productRed = xmlDoc.getElementsByTagName("redTwo");
    for(i = 0; i < productRed.length;i++){
      //((xmlDoc == null)?"NO":"YES");
      document.getElementById(productRed[i].getElementsByTagName("productTurnRed")[0].childNode[0].nodeValue).style.color = "red";
    }
    document.getElementById("testing").innerHTML = productRed.length;
    //document.getElementById("")
    //var = xmlDoc.getElementsByTagName("product")[0].nodeValue;
    //document.getElementById("testing").innerHTML = xmlHttp.responseText;
    //document.getElementById("SRkb4UaJKc").color = "#FF0000";
    //$("th").css("background-color", "#FF0000");

  }
}
