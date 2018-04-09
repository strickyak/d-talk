set Page 0

set in [read stdin]

set basis 5.00
proc size {x} {
	expr {int( $::basis * $x )}
}

proc prelude {} {
  puts [subst -nobackslashes -novariables {
<html>
<head>
	  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	  <meta charset="UTF-8">

	  <style>
	  	.green {
		  color: #00FF00;
		  font-size: [size 100]%;
		  /* font-family: courier, monospace; */
		  font-family: monospace;
		}
		.yellow {
		  color: #FFFF00;
		  font-size: [size 100]%;
		  font-family: monospace;
		}
		.big-green {
		  color: #00FF00;
		  font-size: [size 150]%;
		  font-family: monospace;
		}
		.big-yellow {
		  color: #FFFF00;
		  font-size: [size 130]%;
		  font-family: monospace;
		}
		.title {
		  color: #aaaaaa;
		  font-size: [size 50]%;
		  font-family: Arial, sans-serif;
		  text-align: center;
		}
		.prose {
		  color: #FFFF00;
		  font-size: [size 75]%;
		  font-family: Arial, sans-serif;
		}
		.gloss {
		  color: #bbbbbb;
		  font-size: [size 30]%;
		  font-family: Arial, sans-serif;
		}
	  </style>

	  <script src="jquery-3.3.1.min.js"></script>

	  <script>
	    Page = -1;

	    // Thanks https://stackoverflow.com/questions/13735912/anchor-jumping-by-using-javascript
	    function jump(h) {
		location.href = "#" + h;
	    }

	    $(document).keypress(function(e){
		kc = e.keyCode & 31;
		if (kc == 14) {  // Next
		  ++Page;
		  jump(Page);
		} else if (kc == 16) { // Prev
		  --Page;
		  if (Page < 0) Page = 0;
		  jump(Page);
		} else if (kc == 8) { // Home
		  Page = 0;
		  jump(Page);
		} else if (kc == 20) { // Ten
		  Page = 10;
		  jump(Page);
		}
	    });

	  </script>
</head>
<body bgcolor=#000055>
  }]
}
proc postlude {} {
  puts {
        <br> <br> <br> <br> <br> <br> <br> <br>
        <br> <br> <br> <br> <br> <br> <br> <br>
</body>
</html>
  }
}

proc page {} {
  global Page
  puts [subst -nocommands {
	</div>
        <br> <br> <br> <br> <br>
	<br> <br>
	
	<div class=title>
	  <a name=$Page>[$Page]</a> www.yak.net/d
	</div>
  }]
  incr Page
}

proc class {class s} {
  puts [ subst -nocommands {
	</div>
	<div class=$class>
  } ]
  line $s
}

proc line {s} {
      regsub -all "\t" $s {        } s
      regsub -all {  } $s {\&nbsp; } s
      regsub -all {<<} $s {\&#171; } s
      regsub -all {>>} $s {\&#187; } s
      regsub -all {<} $s {\&lt; } s
      regsub -all {>} $s {\&gt; } s
      regsub -all {[#][#]} $s {\&#9723;} s
      regsub -all {[@][@]} $s {\&#9898;} s
      regsub -all {[%][%]} $s {\&#9671;} s
      regsub -all {[~][~]} $s {\&#172;} s
      regsub -all {[&][&]} $s {\&#8743;} s
      regsub -all {[|][|]} $s {\&#8744;} s
      regsub -all {\^\^} $s {\&#8594;} s
      regsub -all {[[]v[]]} $s {\&#9745;} s
      regsub -all {[[][.][]]} $s {\&#9744;} s
      puts $s<br>
}

prelude
foreach line [split $in "\n"] {
  switch -glob $line {
    /page { page }
    =g* { class green [string range $line 3 end]}
    =y* { class yellow [string range $line 3 end]}
    >g* { class big-green [string range $line 3 end]}
    >y* { class big-yellow [string range $line 3 end]}
    ;* { class gloss [string range $line 2 end]}
    * { class prose $line }
  }
}
postlude
