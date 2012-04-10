//Assume that there is some file which has defined the array ToCheck
var found_urls = new Array();
//Assume urlJSON is defined upstream
ToCheck = mysites;
//Support older browsers
//This prototype is provided by the Mozilla foundation and
//is distributed under the MIT license.
//http://www.ibiblio.org/pub/Linux/LICENSES/mit.license

if (!Array.prototype.every)
{
  Array.prototype.every = function(fun /*, thisp*/)
  {
    var len = this.length;
    if (typeof fun != "function")
      throw new TypeError();

    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in this &&
          !fun.call(thisp, this[i], i, this))
        return false;
    }

    return true;
  };
}
//This prototype is provided by the Mozilla foundation and
//is distributed under the MIT license.
//http://www.ibiblio.org/pub/Linux/LICENSES/mit.license

if (!Array.prototype.forEach)
{
  Array.prototype.forEach = function(fun /*, thisp*/)
  {
    var len = this.length;
    if (typeof fun != "function")
      throw new TypeError();

    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in this)
        fun.call(thisp, this[i], i, this);
    }
  };
}
//Keep on going
function process() {
  //  alert("Processing");
  ToCheck.forEach(process_element);
  //alert("Done processing");
}
//Process an element
function process_element(x,idx) {
  if(is_vissited(x)) {
    mark_as_found(x);
    //alert(x + "is vissited");
  }
}
//Is a site visited
function is_vissited(site) {
    //Check if they have visited www.foo or foo with http or https
    if(vissited("http://www."+site) || vissited("http://"+site) || vissited("https://"+site) || vissited("https://www."+site))  {
	return true;
    }
    return false;
}

function vissited(site) {
  return url_vissited(site);
}

//Is a specific url vissited
function url_vissited(site) {
  document.getElementById("mylink").href=site;
  var l = document.getElementById("mylink");
  var ls =document.getElementById("mylink").currentStyle; 
  var lc;
  var lss;
  if (typeof(ls) == "undefined") {
    if (typeof(document.defaultView) != "undefined") {
	  lc = document.defaultView.getComputedStyle(l,null).color;
	  lss = document.defaultView.getComputedStyle(l,null).fontSize;
    }
  } else {
	lc= ls.color;
	lss = ls.size;
  }
  if (site == "http://www.uwaterloo.ca") {
    alert("for " + site + "lc: " + lc + "ls :"+ lss);
  }
  if ( lc == '#000000' ||
      lss == 42 || lss == "42px"
       || lc == "rgb(0,0,0)") {
    return true;//Hax
  } else {
    return false;
  }
}


function mark_as_found(site) {
    found_urls.push(site);
    //alert("marking as found "+site);
    document.myform.sitelist.value += site;
    document.myform.sitelist.value += "\n";
}

function ua_add() {

}

function ua_handler() {
    //Hack, if the UA is firefox we add mozilla.org
    //If the UA is opera we add opera.com
    //If the UA is chrome we add http://www.google.com/chrome

}

function start() {
  //window.status="Page is loaded";
  //alert("loaded");
  //alert("we have "+ToCheck[0]+" as the first site");
  //alert("and second"+ToCheck[1]);
  //  document.myform.submit();
  ua_add();
  process();
  alert("done");
  //document.myform.submit();
  //alert("shouldn't be here");
}
