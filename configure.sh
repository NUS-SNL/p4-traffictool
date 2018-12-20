#!/bin/bash

install_compiler() { 
	echo "Could not find either of p4c or p4c-bm2-ss"
	echo "Find setup scripts for p4c here https://github.com/jafingerhut/p4-guide"
	echo "Without compiler you can use p4-traffictool only with pre compiled json files as input"
	echo "------------------"
}

echo "Checking Python"
echo "------------------"
python --version > /dev/null 2>&1
if [[ $? != "0" ]]; then
	echo "Could not find Python :("
	echo "Install Python before continuing"
	exit 1
fi
python -c "import tabulate" > /dev/null 2>&1
if [[ $? != "0" ]]; then
	echo "Install Python package 'tabulate' for prettier output"
fi
echo "Python OK"
echo "------------------"

echo "Checking Compilers"
echo "------------------"
p4c-bm2-ss --version > /dev/null 2>&1
DETECT_P4=$?

if [[ $DETECT_P4 != "0" ]]; then
	p4c --version > /dev/null 2>&1
	DETECT_P4=$?
fi

if [[ $DETECT_P4 != "0" ]]; then
	install_compiler
else
	echo "P4 Compiler OK"
fi
echo "Run ./install.sh to install p4-traffictool"
