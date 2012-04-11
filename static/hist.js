//Assume that there is some file which has defined the array ToCheck
var found_urls = new Array();
//Assume urlJSON is defined upstream
ToCheck = mysites;
//Support older browsers
//This prototype is provided by the Mozilla foundation and
//is distributed under the MIT license.
//http://www.ibiblio.org/pub/Linux/LICENSES/mit.license
var tc = 0;
var otc = 0; 

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

function processbit() {
//  alert("processing some...");
  if (tc > ToCheck.length-1) {
otc=tc;
var myl = ToCheck.length+0;
var p = Math.round((100*otc)/(myl));
//myJsProgressBarHandler.setPercentage('element1',p);
//alert("so tc"+tc+"otc"+otc+"p"+p+"myl"+myl);
   fully_done();
  }
  var m;
  m = 0;
  while (m < 500) {
  ++m;
  process_element(ToCheck[tc],null);
  if (tc > ToCheck.length-1) {
otc=tc;
var myl = ToCheck.length+0;
var p = Math.round((100*otc)/(myl));
//myJsProgressBarHandler.setPercentage('element1',p);
//alert("so tc"+tc+"otc"+otc+"p"+p+"myl"+myl);
   fully_done();
  }
  }
  setTimeout("processbit()",5);
}

//Process an element
function process_element(x,idx) {
  if(is_vissited(x)) {
    mark_as_found(x);
    //alert(x + "is vissited");
  }
  tc = tc+1;
  if (tc-otc > 1) {
    otc=tc;
//    var p = Math.round(100*(otc/(ToCheck.length+100)));
    var myl = ToCheck.length+0;
    var p = Math.round((100*otc)/(myl));
    myJsProgressBarHandler.setPercentage('element1',p);
    if (typeof(window.status) != "undefined") {
       window.status="We are "+p+"% through :)";
    }
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
var j = 0;
//Is a specific url vissited
function url_vissited(site) {
  document.getElementById("mylink").href=site;
  //document.getElementById("linktest").innerHTML = document.getElementById("linktest").innerHTML
  document.getElementById("linktest").innerHTML = document.getElementById("linktest").innerHTML;
  var l = document.getElementById("mylink");
  var ls =document.getElementById("mylink").currentStyle; 
  var lc;
  var lss;
  var lc2;
  var lss2;
  var lss3;
  var f;
  
    if (typeof(document.defaultView) != "undefined") {
	  lc2 = document.defaultView.getComputedStyle(l,null).color;
	  lss2 = document.defaultView.getComputedStyle(l,null).fontSize;
    }
  if (typeof(ls) == "undefined") {
	if (j != 3) {
		//alert (":(");
		//alert("hobo doesn't work :(lc2" +lc2 + ",lss2" + lss2 +", no stress l:" + l);
		j = 3;
	}
	lc = lc2;
	lss = lss2;
  } else {
	if (j != 1) {
//		alert("hobo does work");
		j = 1;
	}
	lc= ls.color;
	lss = ls.size;
	lss3 = ls.fontSize;
  }
  if (site == "http://www.uwaterloo.ca") {
    //alert("for " + site + "lc: " + lc + "ls :"+ lss);
  }
  if ( lc == '#000000' || 
       lss == 42 || 
	lss == "42px" || 
	lc2 == 0 || 
	lc == 0 || 
	lc2 == '#000000' || 
	lss2 == 42 || 
	lss2 == "42px" || 
	lss2 == "42pt" || 
	lss3 == 42 || 
	lss3 == "42px" || 
	lss3 == "42pt" || 
	lc == "rgb(0,0,0)") {
	return true;//Hax
  } else {
	if(typeof(l.style)!= "undefined" && ((typeof(l.currentStyle) != "undefined" && l.currentStyle.fontSize == "42px") || (typeof(document.defaultView) != "undefined" && (document.defaultView.getComputedStyle(l,null)).fontSize == "42px")))
		return true;

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
  ua_handler();
}

//Browser detect code from http://www.quirksmode.org/js/detect.html
var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{
			string: navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			prop: window.opera,
			identity: "Opera"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};

//End Browser detect code

function ua_handler() {
    //Hack, if the UA is firefox we add mozilla.org
    //If the UA is opera we add opera.com
    //If the UA is chrome we add http://www.google.com/chrome
    BrowserDetect.init();
	var browser=BrowserDetect.browser;
	var os=BrowserDetect.OS;
	//alert("your browser is" + browser);
    if (typeof(browser) != "undefined")	 {
	if (browser=="Chrome") {
		//mark_as_found("www.google.com/tools/dlpage/res/chrome/images/chrome-16.png");		
		mark_as_found("upload.wikimedia.org/wikipedia/en/3/35/GoogleChromeLogo.png");
	}
	if (browser == "Safari") {
		mark_as_found("apple.com/");
		mark_as_found("upload.wikimedia.org/wikipedia/en/6/61/Apple_Safari.png");
	}
	if (browser == "Opera") {
		mark_as_found("upload.wikimedia.org/wikipedia/en/8/8f/Opera_logo.png");
		mark_as_found("opera.com/");
	}
	if (browser == "iCab") {
		mark_as_found("upload.wikimedia.org/wikipedia/en/e/ec/ICab_icon.png");
		mark_as_found("icab.de/");
	}
	if (browser == "Konqueror") {
		mark_as_found("upload.wikimedia.org/wikipedia/commons/c/ce/Konqueror4_Logo.png");
		mark_as_found("konqueror.org/");
	}
	if (browser == "Firefox" || browser == "FireFox" ) {
	  //alert("ff");
		mark_as_found("upload.wikimedia.org/wikipedia/en/d/d8/Firefox_3.5_logo.png");
	}
	if (browser == "Camino") {
		mark_as_found("upload.wikimedia.org/wikipedia/en/9/95/Camino.png");
		mark_as_found("caminobrowser.org/");
	}
	if (browser == "Netscape") {
		mark_as_found("netscape.com/");
	}
	if (browser =="MSIE") {
		mark_as_found("upload.wikimedia.org/wikipedia/en/1/10/Internet_Explorer_7_Logo.png");
		mark_as_found("microsoft.com/");
	}
	if (browser == "Mozilla") {
		mark_as_found("mozilla.org/");
	}
    }
    if (typeof(os) != "undefined") {
	if (os == "Linux") {
	  mark_as_found("upload.wikimedia.org/wikipedia/commons/3/35/Tux.svg");
	}
	if (os == "Apple") {
	  mark_as_found("upload.wikimedia.org/wikipedia/en/a/ab/Apple-logo.png");
	}
	if (os == "Windows") {
	  mark_as_found("upload.wikimedia.org/wikipedia/en/b/b7/Windows_logo.svg");
	}
    }
    
}


function start() {
  //window.status="Page is loaded";
  //alert("loaded");
  //alert("we have "+ToCheck[0]+" as the first site");
  //alert("and second"+ToCheck[1]);
  //  document.myform.submit();
  var el = document.getElementById("e1");
  if(typeof(el)!="undefined") {
	  document.getElementById("e1").display=true;
  }
  ua_add();
  //alert("starting...");
  processbit();
//  alert("done");
  //alert("shouldn't be here");
}
function fully_done() {
  document.myform.submit();

}
