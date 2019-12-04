
proc  minmaxNC110 { fileName fileName_ptp  } {

set  string_file  ""
set var0 0 ;
global minX maxX minY maxY  minZ maxZ
set  minX  0.0 ;set  maxX 0.0 ; set  minY  0.0 ;set  maxY 0.0 ; set  minZ 0.0 ;set  maxZ 0.0;

set rf [open "$fileName" r ] ; 

set fl 0; set flagT 0;  set flagUCG 0 ; set flagUAO 0 ;
set i 1;   gets $rf  string_file 
while {![eof $rf] } {

set st [regexp -nocase -- {(%)+}  $string_file  var0] 
if {$st!=0} {  set fl 1 }
if {$fl!=0} {

  # Обработка кадров с UCG ------ 
   set st [regexp -nocase -- {(UCG)+}  $string_file  var0 ]
   if {$st!=0} {
      if {$flagUCG==0} { set flagUCG 1 }
     } ; # Обработка кадров с UCG ----------конец

  # Обработка кадров с UAO ------ 
   set st [regexp -nocase -- {(UAO)+}  $string_file  var0 ]
   if {$st!=0} {
      if {$flagUAO==0} { set flagUAO $i }
     } ; # Обработка кадров с UAO ----------конец

   # Обработка кадров с T ------ 
   set st [regexp -nocase -- {(T)([0-9])+([.])*([0-9])+|(T)([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
;# tk_messageBox -icon info -message "i==$i" -type ok
      if {$flagT==0} { set flagT $i }
     } ; # Обработка кадров с T ----------конец
 
   # Обработка кадров с X ------ 
   set st [regexp -nocase -- {(X)([- - +])*([0-9])+([.])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     set var10 ""; set var9  "";
     scan $var0 "%1s %f " var9 var10
     #[info exists var10] 
     if  { $var10!= ""} {  
        if  {$var10<$minX} {  set  minX   $var10 } ; #min
        if  {$var10>$maxX} {  set  maxX   $var10 }; #max
        }
     } ; # Обработка кадров с X ----------конец

   # Обработка кадров с Y ------ 
   set st [regexp -nocase -- {(Y)([- - +])*([0-9])+([.])*([0-9])+}  $string_file  var0 ]
   if {$st!=0} {
     set var10 ""; set var9  "";
     scan $var0 "%1s %f " var9 var10
     #[info exists var10] 
     if  { $var10!= ""} {  
        if  {$var10<$minY} {  set  minY   $var10 } ; #min
        if  {$var10>$maxY} {  set  maxY   $var10 }; #max
        }
     } ; # Обработка кадров с Y ----------конец

# Обработка кадров с Z ------
set st [regexp -nocase -- {(Z)([- - +])*([0-9])+([.])*([0-9])+}  $string_file  var0 ]
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

;# close $rf   ; # close the file  
;# set rf [open "$fileName" r ] ; 

seek  $rf 0 start
set ff [open "$fileName_ptp"  w+ ] ; 

set  minX  [expr $minX-1 ] ; set  minY  [expr $minY-1 ] ; set  minZ  [expr $minZ-1 ] ;
set  maxX  [expr $maxX+1 ] ; set  maxY  [expr $maxY+1 ] ;set  maxZ  [expr $maxZ+1 ] ;

           set str1 [format "%5.4f" $minX ]  ;  set str2 [format "%5.4f" $maxX ]
           set str3 [format "%5.4f" $minY ]  ;  set str4 [format "%5.4f" $maxY ]  
           set str5 [format "%5.4f" $minZ ]   ;  set str6 [format "%5.4f" $maxZ ] 

set fl 0;
set i 1; gets $rf  string_file 
while {![eof $rf] } {
   set st [regexp -nocase -- {(%)+}  $string_file  var0] 
   if {$st!=0} {  set fl 1 }
   if {$fl!=0} { 
   if {$flagUCG==0} { 
       if {[expr $flagUAO+1]==$i} { incr i ; puts $ff  "(UCG,2, X$str1 X$str2 , Y$str3 Y$str4, Z)"  ; incr flagUCG ; }
       if {$flagUCG==0} {
          if {$flagT==$i} { incr i ; puts $ff  "(UCG,2, X$str1 X$str2 , Y$str3 Y$str4, Z)"  ; incr flagUCG ; }
         }
       } 
   } 
 puts $ff  $string_file  ;  
incr i ;  gets $rf  string_file 
}

 puts $ff  $string_file  ;  

flush $ff ;close $ff ;close $rf ; # close the file

file delete "$fileName" ; 
file rename "$fileName_ptp"  "$fileName"

tk_messageBox -icon info -message "Готово\nminX=$minX \nmaxX=$maxX \nminY=$minY \nmaxY=$maxY \nminZ=$minZ\nmaxZ=$maxZ" -type ok

return 0 ;
}

minmaxNC110  "tnc.ptp"  "_tnc.up"
exit ; 
