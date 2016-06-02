var xmlHttp = new XMLHttpRequest();
function refresh(){
  xmlHttp.onreadystatechange = stateChanged;
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}
function stateChanged(){
  if (xmlHttp.readyState==4) {
      document.getElementById("testing").innerHTML = xmlHttp.responseText;
  }
}
