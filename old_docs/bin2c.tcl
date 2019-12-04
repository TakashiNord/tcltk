#!/usr/bin/env tclsh
#
# Convert an input file to a C array for inclusion within a C source file.
#
# Copyright (C) 2013 Lawrence Woodman <http://techtinkering.com>
#
# Licensed under an MIT licence.  Please see LICENCE.md for details.
#
# Usage: 
# Where:
#   inputFilename      The name of the file you want to create an array from.
#   arrayName          The name of the array that you want to create, which
#                      will also have an associated variable with _len
#                      appended to give the length of the array.
#   outputFilename     Optional output filename.  If not specified then output
#                      will be to stdout.
#


proc readBinaryFile {filename} {
  set fid [open $filename r]
  chan configure $fid -translation binary
  set contents [read $fid]
  close $fid
  return $contents
}

proc string2Hex {string} {
  binary scan $string H* hex
  set hex [regsub -all {(..)} $hex {\1 }]
  set hex [string trim $hex]
  return [split $hex]
}

proc getHexLines {hexList valuesPerLine} {
  set hexLength [llength $hexList]
  set output "\n "

  for {set i 0} {$i < $hexLength} {incr i} {
    set num [lindex $hexList $i]
    append output " 0x$num"

    if {$i != $hexLength-1} {
      append output ","
      if {($i+1) % $valuesPerLine == 0} {
        append output "\n "
      }
    }
  }

  return $output
}

proc bin2c {binaryString arrayName outFid} {
  set hexList [string2Hex $binaryString]
  set hexLength [llength $hexList]

  puts -nonewline $outFid "unsigned char $arrayName\[\] = {"
  if {$hexLength != 0} {
    puts $outFid [getHexLines $hexList 12]
  }
  puts $outFid "};"
  puts -nonewline $outFid "unsigned int $arrayName"
  puts $outFid "_len = $hexLength;"
}

# Задаваемые параметры:
set inputFilename "1.tcl"
set arrayName "filetcl"
set outputFilename "1.h"

set inputFileContents [readBinaryFile $inputFilename]
set outFid [open $outputFilename w]
bin2c $inputFileContents $arrayName $outFid
close $outFid