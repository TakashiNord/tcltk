# #!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

proc  checkFileSum { } {

  global ptp_file_name lpt_file_name warning_file_name mom_group_name prev_group_name
  global mom_sys_ptp_output mom_sys_list_output mom_sys_warning_output mom_warning_info

set types {
              {"All Files"  {*.*}  }
              {"PTP Files"  {.ptp} }
              {"UP Files"   {.up}  }
              {"TXT Files"  {.txt} }
              {"DAT Files"  {.dat} }
           }

set fileName [tk_getOpenFile -title "Открыть файл" -filetypes $types ]
if {$fileName==""} {  return -1;  }

set fd [open "$fileName" "r" ] ; 

 set sum  0 ; set l 0 ; set var0 0 ;
 set r [read $fd 1 ] ;
 while {![eof $fd]} {
    incr l ;
    scan $r "%c" var0 ;
    set sF [expr ($sum & 01) ] ;
    if {$sF} { set sum [expr (($sum>>1)|32768)] } else { set sum [expr ($sum>>1) ] ; } 
    set sum [expr $sum^$var0 ] ;
    set r [read $fd 1 ] ;
 }
close $fd ;

;# file stat $fileName s1 ; set s2 $s1(mtime) ;
set s1 [file mtime $fileName ] ; set s2 [clock format $s1 -format "%a %b %d %H:%M:%S %Y" ] ;

set str0 "Файл =" ; append str0 $fileName ;
set str1 "Контрольная Сумма =" ;append str1 [ format "%o" $sum ] ;
set str2 "Число элементов =" ; append str2 "$l" ;
set str3 "Размер файла (в байтах) =" ; append str3 [file size $fileName ] ;
set str4 "Время последнего изменения =" ; append str4 $s2 ;

tk_messageBox -icon info -message "$str0\n$str1\n$str2\n$str3\n$str4" -type ok ;

return 0 ;
}

checkFileSum ;
exit ; 
