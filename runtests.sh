#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"  

mkdir -p tests/tests1
mkdir -p tests/tests2
yes n| ./p4-traffictools.sh -json samples/basic_tunnel/basic_tunnel.json -o tests/tests1 --scapy --wireshark > /dev/null
yes n| ./p4-traffictools.sh -json samples/basic_tunnel/basic_tunnel.json -o tests/tests2 --scapy --wireshark > /dev/null

foo="$(cmp -s tests/tests1/*.py tests/tests1/*.py)"
if [ $foo ]; then
	echo "tests failed"
fi
cd tests
rm -r tests1
rm -r tests2
rm -rf lua_dissector
rm -f tests_data.pcap
yes n| ../p4-traffictools.sh -json ../samples/basic_tunnel/basic_tunnel.json -o . --scapy --wireshark
cp scapy/basic_tunnel.py basic_tunnel.py
python testscript.py
rm -r scapy
rm basic_tunnel.py
rm basic_tunnel.pyc
