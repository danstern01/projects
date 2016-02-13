#!/bin/bash
#
# Set to your gibber lib directory 
#
GIBBER_LIB=$HOME/tools/node_modules/gibber.lib

if [ ! -d $GIBBER_LIB ]
then
	echo "$0: ERROR: GIBBER_LIB='$GIBBER_LIB' not found!" >&2
	exit 1
fi

if [ -L ./build ]
then rm -f ./build
fi

ln -s $GIBBER_LIB/build .
