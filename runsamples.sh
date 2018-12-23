#!/bin/bash
mkdir -p samples/arp/output
mkdir -p samples/basic_tunnel/output
mkdir -p samples/dummy-for-dissector/output
mkdir -p samples/heavy_hitter/output
mkdir -p samples/ipv4_forward/output
mkdir -p samples/mri/output
mkdir -p samples/simple_nat/output
mkdir -p samples/simple_router/output
mkdir -p samples/src_routing/output
mkdir -p samples/tlv_parsing/output
mkdir -p samples/hula/output

# for running in debug mode
yes n|./p4-traffictool.sh -json samples/arp/arp.json --std p4-16 -o samples/arp/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/basic_tunnel/basic_tunnel.json --std p4-16 -o samples/basic_tunnel/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/dummy/dummy.json --std p4-14 -o samples/dummy/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/heavy_hitter/heavy_hitter.json --std p4-14 -o samples/heavy_hitter/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/ipv4/ipv4_forward.json --std p4-16 -o samples/ipv4_forward/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/mri/mri.json --std p4-16 -o samples/mri/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/simple_nat/simple_nat.json --std p4-14 -o samples/simple_nat/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/simple_router/simple_router.json --std p4-14 -o samples/simple_router/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/src_routing/src_routing.json --std p4-16 -o samples/src_routing/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictool.sh -json samples/hula/hula.json --std p4-16 -o samples/hula/output --scapy --wireshark --moongen --pcpp --debug

#example showing variable length fields
# ./p4-traffictool.sh -json samples/tlv_parsing/tlv_parsing.json --std p4-14 -o samples/tlv_parsing/output --scapy --wireshark --moongen --pcpp --debug

