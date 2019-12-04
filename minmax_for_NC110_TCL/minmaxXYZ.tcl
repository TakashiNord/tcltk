#######
proc  minmaxNC110 { fileName fileName_ptp  n  oc1 oc1Min oc1Max oc2 oc2Min oc2Max oc3 fCoord noDivide }  {

set string_file  ""
set var0 0 ;
set  minX  0.0 ;set  maxX 0.0 ; set  minY  0.0 ;set  maxY 0.0 ; set  minZ 0.0 ;set  maxZ 0.0;

set rf [open "$fileName" r ] ;

if {$oc1Min=="" && $oc1Max=="" && $oc2Min=="" && $oc2Max=="" }  {

 set fl 0; set flagT -1; set flagUCG -1 ; set flagUAO -1 ;
 set i 1;   gets $rf  string_file
 while {![eof $rf] } {

  set st [regexp -nocase -- {(%)+}  $string_file  var0]
  if {$st!=0} {  set fl 1 }
  if {$fl!=0} {

   # Обработка кадров с UCG ------
   set st [regexp -nocase -- {(UCG)+}  $string_file  var0 ]
   if {$st!=0} {
      if {$flagUCG==-1} { set flagUCG 1 }
     } ; # Обработка кадров с UCG ----------конец

   # Обработка кадров с UAO ------
   set st [regexp -nocase -- {(UAO)+}  $string_file  var0 ]
   if {$st!=0} {
      if {$flagUAO==-1} { set flagUAO $i }
     } ; # Обработка кадров с UAO ----------конец

   # Обработка кадров с T ------
   set st [regexp -nocase -- {(T)([0-9])+([.])*([0-9])+|(T)([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
      if {$flagT==-1} { set flagT $i }
     } ; # Обработка кадров с T ----------конец

   # Обработка кадров с X ------
   set st [regexp -nocase -- {(X)([- - +])*([0-9])+([.])*([0-9])+|(X)([- - +])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     set var10 ""; set var9  "";
     scan $var0 "%1s %f " var9 var10
     if  { $var10!= ""} {
        if  {$var10<$minX} {  set  minX   $var10 } ; #min
        if  {$var10>$maxX} {  set  maxX   $var10 }; #max
        }
     } ; # Обработка кадров с X ----------конец

   # Обработка кадров с Y ------
   set st [regexp -nocase -- {(Y)([- - +])*([0-9])+([.])*([0-9])+|(Y)([- - +])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     set var10 ""; set var9  "";
     scan $var0 "%1s %f " var9 var10
     if  { $var10!= ""} {
        if  {$var10<$minY} {  set  minY   $var10 } ; #min
        if  {$var10>$maxY} {  set  maxY   $var10 }; #max
        }
     } ; # Обработка кадров с Y ----------конец

   # Обработка кадров с Z ------
   set st [regexp -nocase -- {(Z)([- - +])*([0-9])+([.])*([0-9])+|(Z)([- - +])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
    set var10 "";
    scan $var0 "%1s %f " var9 var10
     if  { $var10!= ""} {
        if  {$var10<$minZ} {  set  minZ   $var10 } ; #min
        if  {$var10>$maxZ} {  set  maxZ   $var10 }; #max
        }
    } ;  # Обработка кадров с Z ----------конец

  incr fl ;
   }  else  { ;  }
    gets $rf  string_file
    incr i ;

}

 seek $rf 0 start ;########## close $rf   ; set rf [open "$fileName" r ] ;

set divideNUM 1 ;

if {$noDivide==0} {
 set var9 0 ;
 set st [ regexp -nocase -- {(\.)+([0-9])*} $fCoord  var9]
 if {$st!=0} {
  if {$var9=="."} {set var9 0 ;}
  set var10 [expr $var9*10 ] ;
  set divideNUM [expr pow(10,$var10) ]
  }

}
 set  minX  [expr ($minX-1)/$divideNUM ] ; set  minY  [expr ($minY-1)/$divideNUM ] ; set  minZ  [expr ($minZ-1)/$divideNUM ] ;
 set  maxX  [expr ($maxX+1)/$divideNUM ] ; set  maxY  [expr ($maxY+1)/$divideNUM ] ; set  maxZ  [expr ($maxZ+1)/$divideNUM ] ;

 set str1 [format $fCoord $minX ]  ;  set str2 [format $fCoord $maxX ] ;
 set str3 [format $fCoord $minY ]  ;  set str4 [format $fCoord $maxY ] ;
 set str5 [format $fCoord $minZ ]  ;  set str6 [format $fCoord $maxZ ] ;

 if {[string toupper $oc1]=="X"}  { set strOc1 "$oc1$str1 $oc1$str2" ; }
 if {[string toupper $oc1]=="Y"}  { set strOc1 "$oc1$str3 $oc1$str4" ; }
 if {[string toupper $oc1]=="Z"}  { set strOc1 "$oc1$str5 $oc1$str6" ; }

 if {[string toupper $oc2]=="X"}  { set strOc2 "$oc2$str1 $oc2$str2" ; }
 if {[string toupper $oc2]=="Y"}  { set strOc2 "$oc2$str3 $oc2$str4" ; }
 if {[string toupper $oc2]=="Z"}  { set strOc2 "$oc2$str5 $oc2$str6" ; }

 set str7 "" ; if {$oc3!=""} { set str7 ",$oc3" ; }

 } else {

  set str1 [format $fCoord $oc1Min ] ; set str2 [format $fCoord $oc1Max ]
  set str3 [format $fCoord $oc2Min ] ; set str4 [format $fCoord $oc2Max ]

  set strOc1 "$oc1$str1 $oc1$str2" ; set strOc2 "$oc2$str3 $oc2$str4" ; set str7 ",$oc3"

    }


set ff [open "$fileName_ptp"  w ] ;

set fl 0;
set nofileSave  0;
set i 1; gets $rf  string_file
while {![eof $rf] } {
 set st [regexp -nocase -- {(%)+}  $string_file  var0]
 if {$st!=0} { set fl 1 ; }
 if {$fl!=0} {
     ; # Если в ленте нет (UCG, ) -> иди на вывод
    if {$flagUCG==-1} {
      if {$flagUAO==-1 && $flagT==-1} {
                puts $ff  $string_file
        incr i ; puts $ff "(UCG,$n, $strOc1 , $strOc2 $str7)";  incr flagUCG ;
        set nofileSave 1 ;
       }
      if {(([expr $flagUAO+1]==[expr $i+0])&&($flagUCG==-1))} { incr i ; puts $ff "(UCG,$n, $strOc1 , $strOc2 $str7)";  incr flagUCG ;}
      if {(($flagUAO==-1) && ($flagUCG==-1) && ($flagT!=-1))} { incr i ; puts $ff "(UCG,$n, $strOc1 , $strOc2 $str7)";  incr flagUCG ; }
      if {(($flagT==$i)&&($flagUCG==-1))} { incr i ; puts $ff "(UCG,$n, $strOc1 , $strOc2 $str7)"; incr flagUCG ; }
   }
 }

 if {$nofileSave==0}  {  puts $ff  $string_file ; }
 set nofileSave  0;

 incr i ;  gets $rf  string_file

}

 puts $ff  $string_file  ;

flush $ff ;close $ff ;close $rf ; # close the file

return 0 ;
}
