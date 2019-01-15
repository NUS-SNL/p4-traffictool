#!/bin/bash
rm -rf samples/basic_postcards/output
rm -rf samples/basic_tunnel/output
rm -rf samples/hula/output
rm -rf samples/linear_road/output
rm -rf samples/mri/output
rm -rf samples/netcache/output
rm -rf samples/netchain/output
rm -rf samples/p4paxos/output
rm -rf samples/qmetadata/output
rm -rf samples/src_routing/output

# for running in debug mode
yes y|./p4-traffictool.sh -json samples/basic_postcards/basic_postcards.json --std p4-16 -o samples/basic_postcards/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/basic_tunnel/basic_tunnel.json --std p4-16 -o samples/basic_tunnel/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/hula/hula.json --std p4-16 -o samples/hula/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/linear_road/linear_road.json --std p4-14 -o samples/linear_road/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/mri/mri.json --std p4-16 -o samples/mri/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/netchain/netchain.json --std p4-16 -o samples/netchain/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/netcache/netcache.json --std p4-16 -o samples/netcache/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/p4paxos/paxos_acceptor.json --std p4-14 -o samples/p4paxos/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/src_routing/src_routing.json --std p4-16 -o samples/src_routing/output --scapy --wireshark --moongen --pcpp --debug
yes y|./p4-traffictool.sh -json samples/qmetadata/qmetadata.json --std p4-16 -o samples/qmetadata/output --scapy --wireshark --moongen --pcpp --debug
