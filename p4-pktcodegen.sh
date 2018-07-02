#!/bin/bash
# usage : <path to p40pktcodegen.sh> <p4-source> <std {p4-14, p4-16}> <destination directory path> [-d] [-scapy] [-lua] [-moongen] [-pcpp]
foldername="`date +%Y%m%d%H%M%S`";
foldername="tempfolder_$foldername"
mkdir $foldername

source_path=$(realpath "$1")

if ([ $2 == "p4-14" ] || [ $2 == "p4-16" ]); then
    standard="$2"
else
    echo "Incorrect Usage"
    rm -r $foldername
    exit 1
fi

cd $foldername

p4c-bm2-ss --std $standard -o alpha.json $source_path > foo
if [ $? != "0" ]; then
    echo "Compilation with p4c-bm2-ss failed...trying with p4c"
    p4c --std $standard $source_path > foo
    if [ $? != "0" ]; then
        echo "Compilation with p4c failed.. exiting"
        rm -r $foldername
        exit 2
    fi
fi
echo "Compilation successful"
if [[ $* == *--d* ]];then
    debug_mode="-d"
else
    debug_mode=""
fi

jsonsource=$(find . -name "*.json" -type f)
jsonsource=$(realpath $jsonsource)
cd ..

destination=$(realpath $3)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

if [[ $* == *-scapy* ]];then
    temp="$destination/scapy"
    mkdir $temp
    python $DIR/src/GenTrafficScapy.py $jsonsource $temp $debug_mode
fi
if [[ $* == *-lua* ]];then
    temp="$destination/lua_dissector"
    mkdir $temp
    python $DIR/src/DissectTrafficLua.py $jsonsource $temp $debug_mode
fi
if [[ $* == *-moongen* ]];then
    temp="$destination/moongen"
    mkdir $temp
    python $DIR/src/GenTrafficMoonGen.py $jsonsource $temp $debug_mode
fi
if [[ $* == *-pcpp* ]];then
    temp="$destination/pcapplusplus"
    mkdir $temp
    python $DIR/src/DissectTrafficPcap.py $jsonsource $temp $debug_mode
fi
rm -r $foldername