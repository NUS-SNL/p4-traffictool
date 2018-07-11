#!/bin/bash
# usage : <path to p40pktcodegen.sh> <p4-source> <std {p4-14, p4-16}> <destination directory path> [-d] [-scapy] [-lua] [-moongen] [-pcpp]

# if no arguments are specified then show usage
if ([[ $* == *--help* ]] || [[ "$#" == "0" ]]); then
    echo "Usage: p4-pktcodegen.sh <path to p4 source> [p4-14/p4-16] <path to destination dir> [-scapy] [-lua] [-moongen] [-pcpp] [--d]"
    exit 0
fi

# creates a temp folder with timestamp to hold json script and compiled binaries
foldername="`date +%Y%m%d%H%M%S`";
foldername="tempfolder_$foldername"
mkdir $foldername

# source and standard specification
source_path=$(realpath "$1")

if ([ "$2" == "p4-14" ] || [ "$2" == "p4-16" ]); then
    standard="$2"
else
    standard="p4-14"
    echo "Using p4-14 standard as default"
fi

cd $foldername

# p4 source compilation
echo -e "----------------------------------\nCompiling p4 source ..."
p4c-bm2-ss --std $standard -o alpha.json $source_path > /dev/null 2>&1
if [ $? != "0" ]; then
    echo "Compilation with p4c-bm2-ss failed...trying with p4c"
    p4c --std $standard $source_path > /dev/null 2>&1
    if [ $? != "0" ]; then
        echo "Compilation with p4c failed.. exiting"
        cd ..
        rm -r $foldername
        exit 1
    else
        echo "Compilation successful with p4c"
    fi

else
    echo "Compilation successful with p4c-bm2-ss"
fi
echo -e "------------------------------------\n"

# set debug mode
if [[ $* == *--d* ]];then
    debug_mode="-d"
else
    debug_mode=""
fi

jsonsource=$(find . -name "*.json" -type f)
jsonsource=$(realpath $jsonsource)
cd ..

# check if destination directory is specified
if ([[ $# > 2 ]]);then
    destination=$(realpath -q $3)
    if [[ $? != "0" ]]; then
        destination=$(realpath "$(dirname "$1")")
        echo -e "Using the directory of source as default destination directory\n"
    fi
fi

# DIR stores the path to p4-pktcodegen script, this is required for calling backend scripts
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# running backend scripts
if [[ $* == *-scapy* ]];then
    temp="$destination/scapy"
    echo "Running Scapy backend script for $1"
    mkdir -p $temp
    python $DIR/src/GenTrafficScapy.py $jsonsource $temp $debug_mode
    echo -e "------------------------------------\n"
fi
if [[ $* == *-lua* ]];then
    temp="$destination/lua_dissector"
    echo "Running Lua dissector backend script for $1"
    mkdir -p $temp
    python $DIR/src/DissectTrafficLua.py $jsonsource $temp $debug_mode
    echo -e "------------------------------------\n"
fi
if [[ $* == *-moongen* ]];then
    temp="$destination/moongen"
    echo "Running MoonGen backend script for $1"
    mkdir -p $temp
    python $DIR/src/GenTrafficMoonGen.py $jsonsource $temp $debug_mode
    echo -e "------------------------------------\n"
fi
if [[ $* == *-pcpp* ]];then
    temp="$destination/pcapplusplus"
    echo "Running PcapPlusPlus backend script for $1"
    mkdir -p $temp
    python $DIR/src/DissectTrafficPcap.py $jsonsource $temp $debug_mode
    echo -e "------------------------------------\n"
fi

# remove tempfolder
rm -r $foldername