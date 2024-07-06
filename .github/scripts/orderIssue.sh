#!/bin/bash

if [[ -z "$1" || -z "$2" || -z "$2" ]]; then
    echo "please pass the parameters: ./$(basename $0) ./command.txt ./PrjDir ./manufacturing/bom.csv"
    return
fi

CMDFILE=$1
PRJDIR=$2
BOMFILE=$3
BOMEXTFILE=$(echo "${BOMFILE%.*}.extract.csv")

#-----------------------------------------------

function CHGCommand(){
    echo "CHG $1 -> $2";
    sed -i -z "s@\"$1\"@\"$2\"@g" $PRJDIR/*.kicad_*
}

function EXTCommand(){
    echo "EXT $1"
    if [ ! -f $BOMEXTFILE ]; then
         head -n 1 $BOMFILE > $BOMEXTFILE
    fi
    $(grep -h "$1" $BOMFILE >> $BOMEXTFILE) || echo "$1 not found";
}

#-----------------------------------------------

rm -f $BOMEXTFILE

grep "^/" $CMDFILE | while read line || [[ -n $line ]];
do
  set -- $line; 
  case $1 in
    "/CHG")
      if [[ -n "$2" && -n "$3" && -z "$4" ]]; then
        CHGCommand "$2" "$3"
      else
        echo "Incorrect number of arguments: $1"
      fi
      ;;
    "/EXT")
      if [[ -n "$2" && -z "$3" ]]; then
        EXTCommand "$2" 
      else
        echo "Incorrect number of arguments $1"
      fi
      ;;
    *)
      echo "Unknown operation: $1"
      ;;
  esac
done
