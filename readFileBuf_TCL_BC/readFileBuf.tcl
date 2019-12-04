#
# Автор программы Родионова Елена
#


 global Buffer n
 set n 25 ; # Размер буфера

#================================================================================
proc Analiz { pl } {
#================================================================================
 global Buffer n
 set var0 ""
 for {set i 0 } {$i<$pl} { incr i }  { set var0 "$var0$Buffer($i)\n" ; }
 after idle {.dialog1.msg configure -wraplength 4i}
 set i [tk_dialog .dialog1 "Dialog with local grab - buffer - .........." "$var0" info 0 OK ]
 #  tk_messageBox -icon info -message "$Buffer($i)" -type ok
 return 0
}

#================================================================================
proc main { void } {
#================================================================================
 global Buffer n
 global sp1 sp2
 global p Num

 global string_file
 set var 0

; #set ptp_file_name "_tnc.up"

 set ptp_file_name [tk_getOpenFile -title "Открыть файл" ]
 if {$ptp_file_name==""}  { return -1 ; }
 set up_file_name "tt_tnc.up"

 set rf [open "$ptp_file_name" r ] ;
 set ff [open "$up_file_name" w ] ;

 set i 0
 set flagBuffer 0
 set j 0
 set Num -1
 set fl 0
 set fl_var 0
 set jp [gets $rf sp1]
 while {$fl==0} {

   set Buffer($i) $sp1 ;
   set p $i;
   if {(($p==[expr $n-1])||([eof $rf]))} {
#      set Num 0; set sp2 "Elena" ;
       Analiz  $p
    }

   if {[eof $rf]}  {

     set fl 1;
     for { set l 0; } {$l<$p} { incr l }  { incr j; set str [format  "%d | %s" $j $Buffer($l)] ; puts $ff  $str }

    } else {

   set st [regexp -nocase -- {(%)+}  $sp1  var0 ] ; if {$st!=0} {  set fl_var  1 }

   if {$fl_var!=0} {

#       if {$p==2}  { set Num 0; set sp2 "Elena" ;  }
#       if {$p==5}  {  set Num 3; set sp2 "dfksf";  }
#       if {$p==11} {  set Num 9; set sp2 "EndofLine" ;  }

       if {$i!=[expr ($n-1)]}  { incr i ; } else {  set flagBuffer 1;  set i [expr $n-1 ]; }
       if {$flagBuffer==1||$Num!=-1} { ;#->
	 incr j; set str [format  "%d | %s" $j $Buffer(0)] ; puts $ff  $str
	 if {$Num==-1}  {
	  for { set k 0; } {$k<[expr ($n-1)]} { incr k }  { set _tmp [expr $k+1 ] ; set Buffer($k) $Buffer($_tmp) ; }
	  } else {
	  if {$Num==0} {
             set Buffer(0) $sp2;
           } else {
                for { set k 0; } {$k<$Num} { incr k } { set _tmp [expr $k+1 ] ; set Buffer($k) $Buffer($_tmp) ; }
                set Buffer($Num) $sp2 ;
                }
	    set Num -1;
	    }

	}

     incr fl_var
   } ; #fl_var

      set jp [gets $rf sp1]


   }

}

 close $rf ; flush $ff; close $ff;

 return 0
}


 main ""
 tk_messageBox -icon info -message "Ready" -type ok
 exit
