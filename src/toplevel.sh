#!/bin/bash

foldername="`date +%Y%m%d%H%M%S`";
foldername="tempfolder_$foldername"
mkdir $foldername

source_path=$(realpath "$1")

if ([ $2 == "p4-14" ] || [ $2 == "p4-16" ]); then
    standard="$2"
else
    echo "Incorrect Usage"
    exit 1
fi

cd $foldername

p4c-bm2-ss --std $standard -o alpha.json $source_path
if [ $? != "0" ]; then
    echo "Compilation with p4c-bm2-ss failed...trying with p4c"
    p4c --std $standard $source_path
    if [ $? != "0" ]; then
        echo "Compilation with p4c failed.. exiting"
        exit 2
    fi
fi
echo "Compilation successful"
if [[ $* == *-d* ]];then
    debug_mode="-d"
else
    debug_mode=""
fi

jsonsource=$(find . -name "*.json" -type f)
jsonsource=$(realpath $jsonsource)
cd ..

destination=$(realpath $3)

if [[ $* == *-scapy* ]];then
    temp="$destination/scapy"
    mkdir $temp
    python GenTraffic.py $jsonsource $temp $debug_mode
fi
if [[ $* == *-lua* ]];then
    mkdir lua
fi
rm -r $foldername