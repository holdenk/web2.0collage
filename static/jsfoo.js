//Assumes nexturl & totalcount are defined somewhere
var sc=0;
var xmlHttp=null; 
var furl=null;
var left;
var nexturl;
var total;
var count=0;
var myj= 0;
function donext() {
  surl= furl +"?skipcount="+sc;
  xmlHttp = new XMLHttpRequest(); 
  xmlHttp.onreadystatechange = ProcessRequest;
  xmlHttp.open( "GET", surl, true );
  xmlHttp.send( null );
}

function ProcessRequest () {
  if ( xmlHttp.readyState == 4 && xmlHttp.status == 200 )  {
    //sc=0;//reset skipcount back to zero
    count++;
    //alert("success I got " + xmlHttp.responseText);
    var tehdata;
    try {
    tehdata = eval("(" + xmlHttp.responseText + ")");
    } catch (e) {
      //alert("oops we fail");
      //Likely an error occured and we didn't get back json
      //instead we got back an error msg
      sc=sc+1;
      setTimeout("donext()",1000);
    }
    sc = 0;
    nexturl = tehdata[0];
    furl=nexturl;
    left = tehdata[1];
    //alert("we have so man left" + left);
    var p = Math.round(((100*(total-left))/total));
    myJsProgressBarHandler.setPercentage('element1',p);
    if (left == 0) {
      document.getElementById("myform").action = nexturl;
      done();
    }
    setTimeout("donext()",10);
  } else if (xmlHttp.readyState == 4 && xmlHttp.status != 200) {
    alert("fail...")
    sc = sc+1;
    //alert("oy vey I'm a ninja!" + count);
    setTimeout("donext()",20);
  }

}

function start() {
  //alert("starting jsfoo handler");
//myJsProgressBarHandler.setPercentage('element1',50);
  sc=0;//By default don't skip anything
  nexturl=document.getElementById("myform").action;
  total = document.getElementById("total").value;
  left = total;
  furl=nexturl;
  setTimeout("donext()",10);
}

function done() {
  //Give our monster time to sleep
  document.myform.submit();
}
