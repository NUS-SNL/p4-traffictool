#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"  

if [[ "$1" == clean ]]; then
	cd tests
	rm -rf lua_dissector
	rm -f tests_data.pcap
	exit 0
fi
mkdir -p tests/tests1
mkdir -p tests/tests2
yes n| ./p4-traffictools.sh -json samples/basic_tunnel/basic_tunnel.json -o tests/tests1 --scapy --wireshark > /dev/null
yes n| ./p4-traffictools.sh -p4 samples/basic_tunnel/basic_tunnel.p4 -o tests/tests2 --scapy --wireshark > /dev/null


foo="$(cmp -s tests/tests1/scapy/*.py tests/tests1/scapy/*.py)"
if [ $foo ]; then
	echo "tests failed, different outputs for json and p4"
	exit 1
fi
cd tests
rm -r tests1
rm -r tests2
rm -rf lua_dissector
rm -f tests_data.pcap
yes n| ../p4-traffictools.sh -json ../samples/basic_tunnel/basic_tunnel.json -o . --scapy --wireshark
cp scapy/basic_tunnel.py basic_tunnel.py
python testscript.py
foo="$(tshark -X lua_script:lua_dissector/init.lua -r tests_data.pcap -Tfields -e p4_mytunnel.proto_id)"
foo=${foo: -4}
if [[ "$foo" = "2048" ]]; then 
	echo "Tests passed"
else
	echo "Could not parse correctly with lua_dissector"
fi
rm -r scapy
rm basic_tunnel.py
rm basic_tunnel.pyc
