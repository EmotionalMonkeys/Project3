
var xmlHttp = new XMLHttpRequest();
function refresh(){
  xmlHttp.onreadystatechange = stateChanged;
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}
function stateChanged(){
  if (xmlHttp.readyState==4) {
      var xmlDoc=xmlHttp.responseXML.documentElement;
       document.getElementById("testing").innerHTML =
       "success";
  }
}
