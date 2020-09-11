#!/bin/bash

p4-traffictool > /dev/null 2>&1
if [[ $? != "0" ]]; then
	echo "Name alias for p4-traffictool not detected"
	echo "If you wish to add it then run install.sh"
fi

cd "$( dirname "${BASH_SOURCE[0]}" )"  

if [[ "$1" == clean ]]; then
	cd tests
	rm -rf lua_dissector
	rm -f tests_data.pcap
	exit 0
fi
mkdir -p tests/tests1
mkdir -p tests/tests2
yes n| ./p4-traffictool.sh -json samples/basic_tunnel/basic_tunnel.json -o tests/tests1 --scapy --wireshark > /dev/null
yes n| ./p4-traffictool.sh -p4 samples/basic_tunnel/basic_tunnel.p4 -o tests/tests2 --scapy --wireshark > /dev/null

ls tests/tests2/scapy/*.py > /dev/null 2>&1
if [[ $? != "0" ]]; then
	echo "No p4c compiler detected"
else
	foo="$(cmp -s tests/tests1/scapy/*.py tests/tests1/scapy/*.py)"
	if [ $foo ]; then
		echo "tests failed, different outputs for json and p4"
		exit 1
	else
		echo "Test for p4 and json input similarity passed"
	fi

fi


cd tests
rm -r tests1
rm -r tests2
rm -rf wireshark
rm -f tests_data.pcap
yes n| ../p4-traffictool.sh -json ../samples/basic_tunnel/basic_tunnel.json -o . --scapy --wireshark > /dev/null
cp scapy/basic_tunnel.py basic_tunnel.py
python testscript.py
foo="$(tshark -X lua_script:wireshark/init.lua -r tests_data.pcap -Tfields -e p4_mytunnel.proto_id)"
foo=${foo: -4}
if [[ "$foo" = "2048" ]]; then 
	echo "Tests for correctness passed"
else
	echo "Could not parse correctly with lua_dissector"
	exit 1
fi
rm -r scapy
rm basic_tunnel.py
rm basic_tunnel.pyc
