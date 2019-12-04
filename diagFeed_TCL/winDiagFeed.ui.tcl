# jCH77: @(#) .tcl (01.03.2003 11:36)

proc winDiagramFeed { root args } {

# Ресурсы
global msg1 msg2 msg3 msg4 msg5 msg6 msg7 msg8 msg9 msg10
global msg11 msg12 msg13 msg14 msg15 msg16 msg17 msg18 msg19 msg20
global msg21 msg22 msg23 msg24 msg25 msg26 msg27 msg28 msg29 msg30
global msg31 msg32 msg33 msg34 msg35 msg36 msg37 msg38 msg39 msg40
set msg1 "maximum feed"
set msg2 "min number of staffs (cadrs)"
set msg3 "max number of staffs (cadrs)"
set msg4 "Calculating............"
set msg5 "Break...."
set msg6 "Unknow command...."
set msg7 "Please enter"
set msg8 "Please enter (>=0)"
set msg9 "- not integer number ; please re-enter"
set msg10 "Diagram of Feeds"
set msg11 "Number's stuffs (cadrs)"
set msg12 "Maximum feed:"
set msg13 "\tfrom:"
set msg14 "Calculations of the diagram..."
set msg15 "\t    to:"
set msg16 ":"
set msg17 "Diagram Feeds"
set msg18 "File"
set msg19 "Open file..."
set msg20 "Decode feed for H33 ?"
set msg21 "Close"
set msg22 "Help"
set msg23 "About.."
set msg24 "Diagram Feeds"
set msg25 "Diagram Feeds for system 'H33' and it modifications\n Author - Rodionova E.A.\nCopyright (c) 1995-2003 KNAAPO, Inc."
set msg26 "Change menu ....  "
set msg27 "Выберите файл"
set msg28 "File ="
set msg29 " |  number of stuffs (cadrs) ="
set msg30 "Please, wait for me....."
set msg31 "I'm ready....."

	# this treats "." as a special case

	if {$root == "."} {
	    set base ""
	} else {
	    set base $root
	}

global  fName ; set  fName "" ;
# Массивы подач и координат
global Gt Ft Xt Yt Zt It Jt Kt ;
global  termN ;  set  termN  0
# подсчитывает сумму дискрет
set SUMX 0
set SUMY 0
set SUMZ 0
#
  global buffer
  set buffer_action 1
  set buffer_size -1
  set buffer_size_max 25

# calculate --
#
# This procedure is invoked whatever Return is typed in any of the entry
# widgets.  It validates the contents of the entries, and recalculates
# the payment information.
#
# Arguments: statusButtons - status entry widget.
# None.
#=============================================================
proc calculate { statusButtons } {
#=============================================================
    global maxFeed minStaff maxStaff msg graph
    global termN
    global msg1 msg2 msg3 msg4 msg5 msg6 msg7 msg8 msg9 msg10

    global msg
    global menustatus
    global menubuttonoptions
    global entryFeedrapid  entryFeed  entryAcceleration

   switch $statusButtons {
      OK {
             if {![validate .frameFeed.e $msg1 ]
	          || ![validate .frameminStaff.e $msg2 ]
	              || ![validate .framemaxStaff.e $msg3 ]} {
	       return
              }
           set msg $msg4
           update idletasks

           if {$maxStaff>$termN} { set maxStaff  $termN }
           if {$minStaff>$maxStaff} { set minStaff $maxStaff  }
           set msg ""
           plot .c $graph(xOrigin) $graph(yOrigin) $graph(width) $graph(height) $maxFeed $minStaff $maxStaff
          }
     OPEN {
            openFile
          }
     CANCEL {
           set msg $msg5 ; update idletasks ; after 1000 ; destroy . ; #destroy %R ;
            }
   default {
           set msg $msg6 ; update idletasks ;
        }
    }

  return ;
}



# validate --
# This procedure is invoked to make sure that an entry contains a valid
# number.  If so, it returns 1.  If not, it sets the global variable
# "msg" with a diagnostic message, moves the input focus to the
# offending entry, and returns 0.
#
# Arguments:
# entry -		Name of the entry widget.
# info -		Description of the value stored in the entry, such
#			as "maxFeed";  used in diagnostic messages.
#=============================================================
proc validate {entry info} {
#=============================================================
global msg1 msg2 msg3 msg4 msg5 msg6 msg7 msg8 msg9 msg10
    global msg
    set value [$entry get]
    if {$value == ""} {
	set msg "$msg7 $info"
	focus $entry
	return 0
    }
    if {$value<0} {
	set msg "$msg8 $info"
	focus $entry
	return 0
    }
    if [catch {expr {2 * $value}}] {
	set msg "$info $msg9"
	$entry selection range 0 end
	focus $entry
	return 0
    }

    return 1
}

# yaxis --
#
# This procedure picks an an appropriate scale factor for the y-axis of
# a plot, and draws the y axis, tick marks, and labels in a canvas.  It
# returns the vertical scale factor to use for the plot (what to
# multiply a y-value by to get a canvas coordinate).
#
# Arguments:
# c -			Canvas in which to draw.
# xOrigin, yOrigin -	Location of the origin for the plot.
# height -		Height of the y-axis, in pixels.
# yMax -		Maximum y-coordinate that will be displayed.
# format -		Format string to use when displaying tick labels
#			(such as %.2f).
#=============================================================
proc yaxis {c xOrigin yOrigin height yMax format} {
#=============================================================
    global axisFont
    if {$yMax==0} { set yMax  1 ; } ; ######
    set log [expr log10($yMax)]
    set unit [expr pow(10, floor($log))]
    set factor [expr $yMax/$unit]
    if {$factor <= 2.0} {
	set unit [expr $unit/5.0]
    } elseif {$factor < 5.0} {
	set unit [expr $unit/2.0]
    }
    set nUnits [expr floor(($yMax + $unit - 1)/$unit)]
   if {$nUnits==0} { set nUnits  1 ; } ; ######
    set scale [expr $height/($unit*$nUnits)]
    $c create line $xOrigin $yOrigin $xOrigin [expr $yOrigin-$height] \
	    -width 1 -fill black
    set x2 [expr $xOrigin + 5]
    for {set i 0} {$i <= $nUnits} {incr i} {
	set y [expr $i*$unit]
	set yCanv [expr $yOrigin - $y * $scale]
	$c create line $xOrigin $yCanv $x2 $yCanv -width 1 -fill black
	$c create text [expr $xOrigin-2] $yCanv -text [format $format $y] \
		-anchor e -font $axisFont -fill black
    }
    return $scale
}

# xaxis --
#
# This procedure is similar to yaxis above except that it handles the
# x-axis instead of a y-axis.
#
# Arguments:
# c -			Canvas in which to draw.
# xOrigin, yOrigin -	Location of the origin for the plot.
# width -		Width of the y-axis, in pixels.
# xMax -		Maximum x-coordinate that will be displayed.
# format -		Format string to use when displaying tick labels
#			(such as %.2f).
#=============================================================
proc xaxis {c xOrigin yOrigin width xMin xMax format} {
#=============================================================
    global axisFont
  set dMax [expr $xMax - $xMin ] ;
    if {$dMax==0} { set dMax  1 ; } ; ######
    set log [expr log10($dMax)]
    set unit [expr pow(10, floor($log))]
    set factor [expr $dMax/$unit]
    if {$factor <= 2.0} {
	set unit [expr $unit/5.0]
    } elseif {$factor < 5.0} {
	set unit [expr $unit/2.0]
    }
    set nUnits [expr floor(($dMax + $unit - 1)/$unit)] ;
   if {$nUnits==0} { set nUnits  1 ; } ; ######
    set scale [expr $width/($unit*$nUnits)]
    $c create line $xOrigin $yOrigin [expr $xOrigin+$width] $yOrigin \
	    -width 1 -fill black
    set y2 [expr $yOrigin - 5]
    for {set i 0} {$i <= $nUnits} {incr i} {
	set x1 [expr $i*$unit+$xMin]
	set x [expr $i*$unit]
	set xCanv [expr $xOrigin + $x * $scale]
	$c create line $xCanv $yOrigin $xCanv $y2 -width 1 -fill black
	$c create text $xCanv [expr $yOrigin+2] -text [format $format $x1] \
		-anchor n -font $axisFont -fill black
    }
    return $scale
}

# plot --
#
# Given information about a loan and a canvas to draw in, create a bar
# chart in the canvas of maxFeed paid, as a function of time, with
# active bars that provide additional information when the mouse passes
# over them.
#
# Arguments:
# c -			Canvas in which to draw.
# xOrigin, yOrigin -	Location of the origin for the plot.
# width, height -	Dimensions of the plot, in pixels.
# maxFeed -		Initial loan amount.
# term -		Duration of loan, in years.
# rate -		Interest rate for the loan, in percent.
# payment -		Monthly payment.

#=============================================================
proc plot {c xOrigin yOrigin width height maxFeed minStaff maxStaff } {
#=============================================================
    global barColor accentColor titleFont axisFont
    global paramCalc

    global msg1 msg2 msg3 msg4 msg5 msg6 msg7 msg8 msg9 msg10
    global msg11 msg12 msg13 msg14 msg15 msg16 msg17 msg18 msg19 msg20

    global Gt Ft Xt Yt Zt It Jt Kt ; ##########

    $c delete all
    set xScale [xaxis $c $xOrigin $yOrigin $width $minStaff $maxStaff  %.0f]
    set yScale [yaxis $c $xOrigin $yOrigin $height $maxFeed %.0f]
    set x [expr $xOrigin + $width/2]

    set str  $msg10 ;
    $c create text $x [expr $yOrigin - $height - 5]  -text $str  -font $titleFont -anchor s
    set str  $msg11 ;
    $c create text $x [expr $yOrigin + [winfo pixels $c 16p]] -text "$str" -font $axisFont -anchor n

    for {set year $minStaff} {[expr $year-1] <=$maxStaff} {incr year} {
      	set msg " "
	set princPaid  $Ft($year) ;
     	set msg [format {N%d  |  F=%s | G=%d | X=%s | Y=%s | Z=%s | I=%s | J=%s | K=%s} \
     	          $year  $princPaid [expr int($Gt($year))] $Xt($year) $Yt($year) $Zt($year) \
     	           $It($year) $Jt($year) $Kt($year) ]

	set x2 [expr $xOrigin + $xScale*$year - $xScale*$minStaff+$xScale]
	set x1 [expr $x2 - $xScale]
	set y1 [expr $yOrigin - $yScale*$princPaid]
	if {$y1 > ([expr $yOrigin-1 ])} { set y1 [expr $yOrigin - 1] ;	}
	set id [$c create rectangle $x1 $y1 $x2 $yOrigin -fill $barColor \
		-outline black -width 1 -tags bar]
	$c bind $id <Enter> [list set msg $msg]
    }
    $c bind bar <Enter> "$c itemconfigure current -fill $accentColor"
    $c bind bar <Leave> "$c itemconfigure current -fill $barColor"
    $c lower bar
}

# resize --
#
# This procedure is invoked when the canvas window used for plotting
# changes size.  It recalculates the geometry of the plot to take
# advantage of all the space available in the canvas.
#
# Arguments:
# c -			Name of the canvas widget that changed size.
#=============================================================
proc resize c {
#=============================================================
    global graph
    set graph(width) [expr [winfo width $c] - [winfo pixels $c 1i]]
    set graph(height) [expr [winfo height $c] - [winfo pixels $c 1i]]
    set graph(xOrigin) [winfo pixels $c .8i]
    set graph(yOrigin) [expr $graph(height) + [winfo pixels $c .5i]]
}


global axisFont
global titleFont
global barColor
global accentColor
global msgColor
global graph

set axisFont "-Adobe-Helvetica-Bold-R-Normal--*-120-*-*-*-*-*-*"
set titleFont "-Adobe-Helvetica-Bold-R-Normal--*-240-*-*-*-*-*-*"
set barColor #7ab8cd
set accentColor #90daf3
set msgColor red
set graph(width) [winfo pixels . 5i]
set graph(height) [winfo pixels . 3i]
set graph(xOrigin) [winfo pixels . 0.8i]
set graph(yOrigin) [winfo pixels . 3.5i]

#eval destroy [winfo child .]

frame .frameFeed
frame .framemaxStaff
frame .frameminStaff
frame .frameMessage
pack .frameFeed .frameminStaff .framemaxStaff -side top -anchor w -fill x

pack .frameMessage -side right -anchor w -fill y
label .frameMessage.lm \
		-borderwidth 0 \
		-foreground black \
		-justify left \
		-text "=-\n=-\n=-\n=-\n=-\n=-" \
		-textvariable paramCalc
	catch {
		.frameMessage.lm configure \
			-font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*}
	}
pack .frameMessage.lm -side right

label .frameFeed.l \
		-borderwidth 0 \
		-foreground black \
		-justify left \
		-text "$msg12"
	catch {
		.frameFeed.l configure \
			-font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*}
	}

	entry .frameFeed.e \
		-foreground #000000000000 \
		-highlightbackground #AE00B200C300 \
		-highlightcolor Black \
		-highlightthickness 1 \
		-insertbackground Black \
		-selectbackground #c3c3c3 \
		-selectborderwidth 1 \
		-selectforeground Black \
		-textvariable maxFeed
	catch {
		.frameFeed.e configure \
			-font {-*-interface user-Medium-R-Normal-*-*-120-*-*-*-*-*-*}
	}

bind .frameFeed.e <Return> { calculate OK }
pack .frameFeed.l .frameFeed.e -side left

label .frameminStaff.l \
		-borderwidth 0 \
		-foreground black \
		-justify left \
		-text "$msg13"
	catch {
		.frameminStaff.l configure \
			-font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*}
	}

	entry .frameminStaff.e \
		-foreground #000000000000 \
		-highlightbackground #AE00B200C300 \
		-highlightcolor Black \
		-highlightthickness 1 \
		-insertbackground Black \
		-selectbackground #c3c3c3 \
		-selectborderwidth 1 \
		-selectforeground Black \
		-textvariable minStaff
	catch {
		.frameminStaff.e configure \
			-font {-*-interface user-Medium-R-Normal-*-*-120-*-*-*-*-*-*}
	}

bind .frameminStaff.e <Return> { calculate OK }
pack .frameminStaff.l .frameminStaff.e -side left

button .frameminStaff.calculate -text "$msg14" -command { calculate OK }
	catch {
		.frameminStaff.calculate configure \
			-font {-*-MS Sans Serif-Medium-R-Normal-*-*-160-*-*-*-*-*-*}
	}
pack .frameminStaff.calculate -side right -expand 1

label .framemaxStaff.l \
		-borderwidth 0 \
		-foreground black \
		-justify left \
		-text "$msg15"
	catch {
		.framemaxStaff.l configure \
			-font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*}
	}

	entry .framemaxStaff.e \
		-foreground #000000000000 \
		-highlightbackground #AE00B200C300 \
		-highlightcolor Black \
		-highlightthickness 1 \
		-insertbackground Black \
		-selectbackground #c3c3c3 \
		-selectborderwidth 1 \
		-selectforeground Black \
		-textvariable maxStaff
	catch {
		.framemaxStaff.e configure \
			-font {-*-interface user-Medium-R-Normal-*-*-120-*-*-*-*-*-*}
	}

bind .framemaxStaff.e <Return> { calculate OK }
pack .framemaxStaff.l .framemaxStaff.e -side left

label .pay \
                -anchor w \
		-borderwidth 0 \
		-foreground black \
		-justify left \
		-text "$msg16"
	catch {	.pay configure -font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*} }

pack .pay -side top -fill x
canvas .c -width 500 -height 300 -relief sunken -bd 2
pack .c -side top -anchor w -fill both -expand yes
bind .c <Configure> {resize .c}

label .msg \
                -anchor w \
		-borderwidth 0 \
		-foreground $msgColor \
		-justify left \
		-textvariable msg
	catch {	.msg configure -font {-*-interface user-Medium-R-Normal-*-*-160-*-*-*-*-*-*} }
pack .msg -side top -fill x

wm title $root "$msg17"

# Построение Меню
menu $base.menu -tearoff 0

set m $base.menu.file
menu $m -tearoff 0
$base.menu add cascade -label "$msg18" -menu $m -underline 0
$m add command -label "$msg19" -command {calculate "OPEN" }
$m add separator
$m add check -label "$msg20" -variable checkN33
$m add separator
$m add command -label "$msg21" -command { calculate "CANCEL"  }
$m invoke 2

set m $base.menu.about
$base.menu add cascade -label "$msg22" -menu $m -underline 0
menu $m -tearoff 0
$m add command -label "$msg23" -command  { tk_messageBox -icon info -type ok -title $msg24 -message $msg25 }

$root configure -menu $base.menu
update

#
bind Menu <<MenuSelect>> {
    global msg
    if {[catch {%W entrycget active -label} label]} { set label $msg26 }
    set msg $label
    update idletasks
}
#

return 0;
}

##############################################################################################
#=============================================================
proc openFile {  } {
#=============================================================
 global msg21 msg22 msg23 msg24 msg25 msg26 msg27 msg28 msg29 msg30 msg31
 global msg
 global fName  termN  maxF
 global maxFeed minStaff maxStaff

 set varfName [tk_getOpenFile -title $msg27 ]
 if  {$varfName==""} {
   if {$fName==""} {  set msg "" ;  set  termN 0 ; }
  } else {
   	set fName  $varfName ;
   	set msg "$msg30" ; update idletasks ;
   	set termN  [NC $fName ] ;
   	set msg "$msg31" ; update idletasks ;
   	set maxFeed $maxF ; set minStaff  0 ;  set maxStaff  $termN
    }
  .pay configure -text  "$msg28'$fName'$msg29$termN" ; update idletasks ;
  return 0
}


#=============================================================
proc NC { fileName } {
#=============================================================
  global checkN33
  global maxF ; set maxF 0.0 ;

  global Gt Ft Xt Yt Zt It Jt Kt ; # массивы определения
  set SUMX 0 ;  set SUMY 0 ; set SUMZ 0 ; # подсчитывает сумму дискрет

  if {$fileName==""} {  return 0 }

  set Gt(0) 1 ;set Ft(0) 0 ;set Xt(0) 0 ;set Yt(0) 0 ;set Zt(0) 0 ;set It(0) 0 ;set Jt(0) 0 ;set Kt(0) 0 ;

  catch { unset Gt Ft Xt Yt Zt It Jt Kt } ;

  global string_file  ;
  set var0  0 ;

 set rf [open "$fileName" "r" ] ;

set i 0 ; set fl 0 ;
while {![eof $rf] } {

 gets $rf  string_file

 set st [regexp -nocase -- {(%)+}  $string_file  var0]
 if {$st!=0} { set fl 1 }

 if {$fl>0} {

   set buf($i) "$string_file"

   set st [regexp -nocase -- {(G)([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     	set var10 ""; set var9  "";
     	scan $var0 "%1s %f" var9 var10
     	if  {$var10!=""} {   set  Gt($i)  $var10 } else  { set  Gt($i)  1 }
     } else {
     	set _tmp [expr ($i-1)]
     	if {[info exists  Gt($_tmp)]==0} { set  Gt($i) 1 ; } else { set  Gt($i)  $Gt($_tmp) ;  }
     } ;

  set st [regexp -nocase -- {(F)([0-9])+}   $string_file  var0 ]
  if {$st!=0} {
  	set var10 "";
   	scan $var0 "%1s %4f" var9 var10
   	if {[info exists checkN33]==0} { set checkN33 0 ; }
   	if {$checkN33} { set var10 [ decodeFeed $var10 ] ; }
  	if  {$var10!=""} {   set  Ft($i) $var10 } else { set  Ft($i) 0 ; }
   } else {
     	set _tmp [expr ($i-1)]
     	if {[info exists Ft($_tmp)]==0} { set Ft($i) 0 } else { set  Ft($i)  $Ft($_tmp) ;  }
    } ;

   if {$maxF<$Ft($i)} { set maxF $Ft($i) }

   #set st [regexp -nocase -- {(T)([0-9])*}  $string_file  var0 ]
   #if {$st!=0} { if {$flagT==0} { set flagT $i }  } ;

   set st [regexp -nocase -- {(X)([- - +])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     	set var10 0; set var9  "";
     	scan $var0 "%1s %f" var9 var10
     	set  Xt($i) [expr int($var10) ]
     } else { set Xt($i) 0 }

   set st [regexp -nocase -- {(Y)([- - +])*([0-9])*}  $string_file  var0 ]
   if {$st!=0} {
     	set var10 ""; set var9  "";
     	scan $var0 "%1s %f" var9 var10
     if  {$var10!=""} { set Yt($i) $var10 } else  {   set  Yt($i) 0 }
      } else {	set  Yt($i) 0  } ;

   set st [regexp -nocase -- {(Z)([- - +])*([0-9])*}  $string_file  var0 ]
   if {$st!=0} {
    	set var10 "";
    	scan $var0 "%1s %f " var9 var10
    if  {$var10!=""} {   set  Zt($i)  "$var10" } else  {   set Zt($i) 0 }
     } else { set  Zt($i) 0  }

   set st [regexp -nocase -- {(I)([- - +])*([0-9])*}  $string_file  var0 ]
   if {$st!=0} {
    	set var10 "";
    	scan $var0 "%1s %f " var9 var10
    if  {$var10!=""} {   set  It($i)  "$var10" } else  {   set It($i) 0 }
     } else {
     	set _tmp [expr ($i-1)]
     	if {[info exists  It($_tmp)]==0} { set  It($i) 0 } else { set  It($i)  $It($_tmp)  }
    } ;

   set st [regexp -nocase -- {(J)([- - +])*([0-9])*}  $string_file  var0 ]
   if {$st!=0} {
    	set var10 "";
    	scan $var0 "%1s %f " var9 var10
    	if  {$var10!=""} {   set  Jt($i)  "$var10" } else  {   set Jt($i) 0 }
     } else {
     	set _tmp [expr ($i-1)]
     	if {[info exists  Jt($_tmp)]==0} { set  Jt($i) 0  } else { set  Jt($i)  $Jt($_tmp)  }
    } ;

   set st [regexp -nocase -- {(K)([- - +])*([0-9])*}  $string_file  var0 ]
   if {$st!=0} {
    	set var10 "";
    	scan $var0 "%1s %f " var9 var10
    if  {$var10!=""} {   set  Kt($i)  "$var10" } else  {   set Kt($i) 0 }
     } else {
     	set _tmp [expr ($i-1)]
     	if {[info exists Kt($_tmp)]==0} { set Kt($i) 0  } else { set  Kt($i)  $Kt($_tmp)  }
    } ;

   incr fl ;
   incr i ;
 } else  { ; }

}

	close $rf

	return $i
}




proc VEC_line_tan { p_begin  p_end  tan_vec  tp_angle } {
#=============================================================
 upvar $p_begin p1 ;  upvar $p_end p2  ;upvar $tan_vec v  ;
 if {$tp_angle==1} {
    VEC3_sub  p2 p1 v ; # v=p2-p1
   } else {
    VEC3_sub  p1 p2 v ; # v=p1-p2
  }
 return 0;
}

proc VEC_circular_tan { p_begin p_end p_center p_arc_angle tan_vec_cur tp_angle } {
#=============================================================
 upvar $p_begin p1 ; upvar $p_end p2 ; upvar $p_center pc  ; upvar $tan_vec_cur vt  ;
 VEC3_sub  p1 pc v1 ;
 VEC3_sub  p2 pc v2 ;
 VEC3_cross v1 v2 wt ;
 if {[EQ_is_gt $p_arc_angle 180.0]==1} {
        for {set ii 0} {$ii < 3} {incr ii} { set wt($ii) [expr ((-1.0) * $wt($ii))] }
 }
 if {$tp_angle==1} {   VEC3_cross wt v1 vt  } else {   VEC3_cross wt v2 vt  }
 return 0;
}

#=============================================================
proc VEC_angle_vec { v_tan1 v_tan2 } {
#=============================================================
 upvar $v_tan1 v1 ;  upvar $v_tan2 v2  ;
#
 set angle 0.0
 if {[VEC3_is_zero v1 ]} { return $angle }
 if {[VEC3_is_zero v2 ]} { return $angle }
 set len1 [ VEC3_mag v1 ] ;
 set len2 [ VEC3_mag v2 ] ;
 set scal [ VEC3_dot v1 v2 ] ;
 set RAD2DEG [expr 90.0 / asin(1.0)]  ; #multiplier to convert radians to degrees
 set tm [expr ($scal/($len1*$len2)) ]
 if {[EQ_is_ge $tm 1.0 ]}  { set tm 1.0 ; }
 if {[EQ_is_le $tm -1.0 ]}  { set tm -1.0 ; }
 set angle [expr acos($tm) ]
 set angle [expr $RAD2DEG*$angle ]
 if {[EQ_is_zero $angle]} { set angle 0.0 ; }
 return $angle ;
}

#=============================================================
proc VEC_different { ffeed vec vec_dif } {
#=============================================================
 upvar $vec vec_tan  ;  upvar $vec_dif vec_orto ;
 VEC3_unitize vec_tan vec_orto
 VEC_angle_text 0 "Компоненты касательного вектора=( $vec_orto(0), $vec_orto(1), $vec_orto(2) )"
 VEC3_scale ffeed  vec_orto  vec_orto
 VEC_angle_text 0 "Перепад подач по осям=( $vec_orto(0), $vec_orto(1), $vec_orto(2) )"
 return 0
}

#================================================================================
proc codeFeed { fmode ffeed }  {
# fmode - режим ; ffeed - подача в мм/мин ; - общий случай (ГОСТ - кодирования)
#================================================================================
;# проверка исходных данных
  set ffeed [ format "%f" $ffeed ]
  if {$ffeed<0.0}  { set ffeed 0 ; }
  if {$fmode==0 || $fmode==4}  {  } { set fmode 0 ; }

  set intf [ expr int($ffeed) ] ;
  set n 0 ; # число знаков до запятой
  while {$intf!=0} {
  	set intf [ expr int($intf/10.0) ] ;
  	incr n ;
  }

  set drobf [ expr abs($ffeed - int($ffeed)) ] ;
  set m 0 ; # число нулей после запятой
  if {$drobf>0.0000001} {
  	set m  [ expr int ( abs ( log10($drobf) ) ) ]
   }

 set ffeed_tmp [ expr ($ffeed*100.0)/(pow(10,$n)) ]

 set ffeed_tmp [expr round($ffeed_tmp)] ;
 #set ffeed_tmp [expr int($ffeed_tmp)];

 if {$n==0} {
 	switch $m {
 	  1 { set ffeed_tmp "0$ffeed_tmp" ;
 	      set m  0  ;
 	  }
 	  default {
 	  	if {$m>3} { set m 3 } ;
 	  	set ffeed_tmp [ expr ( $ffeed * 100.0 * pow(10,$m) ) ]
 	  	set ffeed_tmp [expr int($ffeed_tmp)];
 	   }
 	 }
  } else {
	if {$n>=7} { set n 6 }
	set m 0
   }

 set kf [ expr $n + 3 - $m ]
 set tmp [format  "%1d%1d%.2s"  $fmode $kf $ffeed_tmp] ;
 set code_feed [ format "%f" $tmp ]

 return $code_feed
}


#================================================================================
proc decodeFeed { ffeed }  {
# ffeed - общий случай , ГОСТ - обозначения
#================================================================================
;# проверка исходных данных
  set tmp [ format "%f" $ffeed ]
  set ffeed [ expr int($tmp) ]
  if {$ffeed<0.0}  { set ffeed 0 ; }

  set fmode 0
  if {$ffeed>4000} { set ffeed [ expr $ffeed - 4000 ] ; set fmode 4 ; }

  set ffeed_tmp [ expr $ffeed/100.0 ] ;
  set intf [ expr int($ffeed_tmp) ] ;
  set ffeed_tmp [ expr $ffeed_tmp-$intf ] ;
  set kf [ expr $intf - 3 ] ;

  set ffeed_tmp [ expr $ffeed_tmp*pow(10,$kf) ] ;

  set code_feed  [format "%f" $ffeed_tmp ] ;

 return $code_feed
}

#_______________________________________________________________________________
         set mom_system_tolerance                   .0000001
#_______________________________________________________________________________
set PI [expr 2.0 * asin(1.0)]                    ; #value PI
set RAD2DEG [expr 90.0 / asin(1.0)]              ; #multiplier to convert radians to degrees
set DEG2RAD [expr asin(1.0) / 90.0]              ; #multiplier to convert degrees to radians

###############################################################################
#
# DESCRIPTION
#
#   Procs used to detect equality between scalars of real data type.
#
#  global mom_system_tolerance
#  EQ_is_equal(s, t)  (abs(s-t) <= mom_system_tolerance) Return true if scalars are equal
#  EQ_is_ge(s, t)     (s > t - mom_system_tolerance)     Return true if s is greater than
#                                            or equal to t
#  EQ_is_gt(s, t)     (s > t + mom_system_tolerance)     Return true if s is greater than t
#  EQ_is_le(s, t)     (s < t + mom_system_tolerance)     Return true if s is less than or
#                                            equal to t
#  EQ_is_lt(s, t)     (s < t - mom_system_tolerance)     Return true if s is less than t
#  EQ_is_zero(s)      (abs(s) < mom_system_tolerance)    Return true if scalar is zero
################################################################################
proc  EQ_is_equal {s t} {
         global mom_system_tolerance

         if { [expr abs($s - $t)] <= $mom_system_tolerance } { return 1 } else { return 0 }
}
proc  EQ_is_ge {s t} {
         global mom_system_tolerance

         if { $s > [expr ($t - $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_gt {s t} {
         global mom_system_tolerance

         if { $s > [expr ($t + $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_le {s t} {
         global mom_system_tolerance

         if { $s < [expr ($t + $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_lt {s t} {
         global mom_system_tolerance

         if { $s < [expr ($t - $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_zero {s} {
         global mom_system_tolerance

         if { [expr abs($s)] <= $mom_system_tolerance } { return 1 } else { return 0 }
}

################################################################################
#
# DESCRIPTION
#
#   Procs used to manipulate vectors
#
#  VEC3_add(u,v,w)                  w = u + v          Vector addition
#  VEC3_cross(u,v,w)                w = ( u X v )      Vector cross product
#  VEC3_dot(u,v)                    (u dot v)          Vector dot product
#  VEC3_init(x,y,z,w)               w = (x, y, z)      Initialize a vector from
#                                                      coordinates
#  VEC3_is_equal(u,v,tol)           (||(u-v)|| < tol)  Are vectors equal?
#  VEC3_is_zero(u,tol)              (|| u || < tol)    Is vector zero?
#  VEC3_mag(u)                      ( || u || )        Vector magnitude
#  VEC3_negate(u,w)                 w = (-u)           Vector negate
#  VEC3_scale(s,u,w)                w = (s*u)          Vector scale
#  VEC3_sub(u,v,w)                  w = u - v          Vector subtraction
#  VEC3_unitize(u,tol,len,w)        *len = || u ||     Vector unitization
#                                   w = u / *len
################################################################################

#  VEC3_add(u,v,w)                  w = u + v          Vector addition
proc  VEC3_add {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($u1($ii) + $v1($ii))]
      }
}

#  VEC3_cross(u,v,w)                w = ( u X v )      Vector cross product
proc  VEC3_cross {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      set w1(0) [expr ($u1(1) * $v1(2) - $u1(2) * $v1(1))]
      set w1(1) [expr ($u1(2) * $v1(0) - $u1(0) * $v1(2))]
      set w1(2) [expr ($u1(0) * $v1(1) - $u1(1) * $v1(0))]
}

#  VEC3_dot(u,v)                    (u dot v)          Vector dot product
proc  VEC3_dot {u v} {
      upvar $u u1 ; upvar $v v1
      return  [expr ($u1(0) * $v1(0) + $u1(1) * $v1(1) + $u1(2) * $v1(2))]
}

#  VEC3_init(x,y,z,w)               w = (x, y, z)      Initialize a vector from
#                                                      coordinates
proc  VEC3_init {x y z w} {
      upvar $x x1 ; upvar $y y1 ; upvar $z z1 ; upvar $w w1
      set w1(0) $x1 ; set w1(1) $y1 ; set w1(2) $z1
}

#  VEC3_is_equal(u,v,tol)           (||(u-v)|| < tol)  Are vectors equal?
proc  VEC3_is_equal {u v} {
      upvar $u u1 ; upvar $v v1
      set is_equal 1
      for {set ii 0} {$ii < 3} {incr ii} {
          if {![EQ_is_equal $u1($ii) $v1($ii)]} {
              set is_equal 0
              break
          }
      }
      return $is_equal
}

#  VEC3_is_zero(u,tol)              (|| u || < tol)    Is vector zero?
proc  VEC3_is_zero {u} {
      upvar $u u1
      set v1(0) 0.0 ; set v1(1) 0.0 ; set v1(2) 0.0
      set is_equal 1
      for {set ii 0} {$ii < 3} {incr ii} {
          if {![EQ_is_equal $u1($ii) $v1($ii)]} {
              set is_equal 0
              break
          }
      }
      return $is_equal
}

#  VEC3_mag(u)                      ( || u || )        Vector magnitude
proc  VEC3_mag {u} {
      upvar $u u1
      return [expr (sqrt([VEC3_dot u1 u1]))]
}

#  VEC3_negate(u,w)                 w = (-u)           Vector negate
proc  VEC3_negate {u w} {
      upvar $u u1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr (-$u1($ii))]
      }
}

#  VEC3_scale(s,u,w)                w = (s*u)          Vector scale
proc  VEC3_scale {s u w} {
      upvar $s s1 ; upvar $u u1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($s1 * $u1($ii))]
      }
}

#  VEC3_sub(u,v,w)                  w = u - v          Vector subtraction
proc  VEC3_sub {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($u1($ii) - $v1($ii))]
      }
}

#  VEC3_unitize(u,tol,len,w)        *len = || u ||     Vector unitization
#                                   w = u / *len
proc  VEC3_unitize {u w} {
      upvar $u u1 ; upvar $w w1
      if {[VEC3_is_zero u1]} {
         set len 0.0
         VEC3_init 0.0 0.0 0.0 w1
      } else {
         set len [VEC3_mag u1]
         set scale [expr (1.0/$len)]
         VEC3_scale scale u1 w1
      }
      return $len
}

################################################################################
#
# DESCRIPTION
#
#   Procs used to manipulate matrices
#
#  MTX3_init_x_y_z (u, v, w, r) r = (u, v, w)      Initialize a matrix from
#                                                  given x, y and z vectors
#  MTX3_is_equal(m,n,a)         (m == n)           Determine if two matrices
#                                                  are equal to within a given
#                                                  tolerance
#  MTX3_multiply(m, n, r)       r = ( m X n )      Matrix multiplication
#  MTX3_transpose(m, r)         r = trns(m)        Transpose of matrix
#  MTX3_scale(s,r)              r = (s*(u))        Scale a matrix by s
#  MTX3_sub(m,n,r)              r = (m - n)        Matrix subtraction
#  MTX3_add(m,n,r)              r = (m - n)        Matrix addition
#  MTX3_vec_multiply(u, m, w)   w = (u X m)        Vector/matrix multiplication
#  MTX3_x(m, w)                 w = (1st column)   First column vector of matrix
#  MTX3_y(m, w)                 w = (2nd column)   Second column vector of matrix
#  MTX3_z(m, w)                 w = (3rd column)   Third column vector of matrix
################################################################################

#  MTX3_init_x_y_z (u, v, w, r) r = (u, v, w)      Initialize a matrix from
#                                                  given x, y and z vectors
proc  MTX3_init_x_y_z { u v w r } {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1 ; upvar $r r1
      set status 0

#   Unitize the input vectors and proceed if neither vector is zero.

    if {[VEC3_unitize u1 xxxxx] && \
        [VEC3_unitize v1 yyyyy] && \
        [VEC3_unitize w1 zzzzz]} {

#       Proceed if the input vectors are orthogonal

        if {[EQ_is_zero [VEC3_dot xxxxx yyyyy]] && \
            [EQ_is_zero [VEC3_dot xxxxx zzzzz]] && \
            [EQ_is_zero [VEC3_dot yyyyy zzzzz]]} {

#           Cross the unitized input vectors and initialize the matrix
#           Orthonormal test is stricter than EQ_ask_systol, so
#           recalculate y and z.

            set status 1
            VEC3_cross xxxxx yyyyy zzzzz
            set len [VEC3_unitize zzzzz zzzzz]
            VEC3_cross zzzzz xxxxx yyyyy

            set r1(0) $xxxxx(0)
            set r1(1) $xxxxx(1)
            set r1(2) $xxxxx(2)
            set r1(3) $yyyyy(0)
            set r1(4) $yyyyy(1)
            set r1(5) $yyyyy(2)
            set r1(6) $zzzzz(0)
            set r1(7) $zzzzz(1)
            set r1(8) $zzzzz(2)

        }
    }
    return $status
}

#  MTX3_is_equal(m,n,a)         (m == n)           Determine if two matrices
#                                                  are equal to within a given
#                                                  tolerance
proc  MTX3_is_equal { m n } {
      upvar $m m1 ; upvar $n n1
      for {set ii 0} {$ii < 9} {incr ii} {
        if {![EQ_is_equal $m1($ii) $n1($ii)]} {return 0}
      }
      return 1
}

#  MTX3_multiply(m, n, r)       r = ( m X n )      Matrix multiplication
proc  MTX3_multiply { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      set r1(0) [expr ($m1(0) * $n1(0) + $m1(3) * $n1(1) + $m1(6) * $n1(2))]
      set r1(1) [expr ($m1(1) * $n1(0) + $m1(4) * $n1(1) + $m1(7) * $n1(2))]
      set r1(2) [expr ($m1(2) * $n1(0) + $m1(5) * $n1(1) + $m1(8) * $n1(2))]
      set r1(3) [expr ($m1(0) * $n1(3) + $m1(3) * $n1(4) + $m1(6) * $n1(5))]
      set r1(4) [expr ($m1(1) * $n1(3) + $m1(4) * $n1(4) + $m1(7) * $n1(5))]
      set r1(5) [expr ($m1(2) * $n1(3) + $m1(5) * $n1(4) + $m1(8) * $n1(5))]
      set r1(6) [expr ($m1(0) * $n1(6) + $m1(3) * $n1(7) + $m1(6) * $n1(8))]
      set r1(7) [expr ($m1(1) * $n1(6) + $m1(4) * $n1(7) + $m1(7) * $n1(8))]
      set r1(8) [expr ($m1(2) * $n1(6) + $m1(5) * $n1(7) + $m1(8) * $n1(8))]
}

#  MTX3_transpose(m, r)         r = trns(m)        Transpose of matrix
proc  MTX3_transpose { m r } {
      upvar $m m1 ; upvar $r r1
      set r1(0) $m1(0)
      set r1(1) $m1(3)
      set r1(2) $m1(6)
      set r1(3) $m1(1)
      set r1(4) $m1(4)
      set r1(5) $m1(7)
      set r1(6) $m1(2)
      set r1(7) $m1(5)
      set r1(8) $m1(8)
}

#  MTX3_scale(s,r)              r = (s*(u))        Scale a matrix by s
proc  MTX3_scale { s r } {
      upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($s * $r1($ii))]
      }
}

#  MTX3_sub(m,n,r)              r = (m - n)        Matrix subtraction
proc  MTX3_sub { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($m1($ii) - $n1($ii))]
      }
}

#  MTX3_add(m,n,r)              r = (m + n)        Matrix addition
proc  MTX3_add { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($m1($ii) + $n1($ii))]
      }
}

#  MTX3_vec_multiply(u, m, w)   w = (u X m)        Vector/matrix multiplication
proc  MTX3_vec_multiply { u m w } {
      upvar $u u1 ; upvar $m m1 ; upvar $w w1
      set w1(0) [expr ($u1(0) * $m1(0) + $u1(1) * $m1(1) + $u1(2) * $m1(2))]
      set w1(1) [expr ($u1(0) * $m1(3) + $u1(1) * $m1(4) + $u1(2) * $m1(5))]
      set w1(2) [expr ($u1(0) * $m1(6) + $u1(1) * $m1(7) + $u1(2) * $m1(8))]
}

#  MTX3_x(m, w)                 w = (1st column)   First column vector of matrix
proc  MTX3_x { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(0)
      set w1(1) $m1(1)
      set w1(2) $m1(2)
}

#  MTX3_y(m, w)                 w = (2nd column)   Second column vector of matrix
proc  MTX3_y { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(3)
      set w1(1) $m1(4)
      set w1(2) $m1(5)
}

#  MTX3_z(m, w)                 w = (3rd column)   Third column vector of matrix
proc  MTX3_z { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(6)
      set w1(1) $m1(7)
      set w1(2) $m1(8)
}




winDiagramFeed . ""


#exit;