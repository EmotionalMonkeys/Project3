var xmlHttp = new XMLHttpRequest();
function refresh(){
  xmlHttp.onreadystatechange = stateChanged;
  xmlHttp.open("GET","refresh.jsp",true);
  xmlHttp.send(null);
}
function stateChanged(){
  if (xmlHttp.readyState==4) {
    document.getElementById("SRkb4UaJKc").color = "#FF0000";
     //$("th").css("background-color", "#FF0000");
  }
}
