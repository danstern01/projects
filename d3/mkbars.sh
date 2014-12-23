#!/bin/ksh

function foo {
  integer i=0
  while(($i<$2))
  do
	echo "2014-${1}-${i},$RANDOM"
	i=$i+1
  done
}

echo "date,value"

#foo 6 30
#foo 7 31
#foo 8 31
#foo 9 30
#foo 10 31
foo 11 30
foo 12 22
