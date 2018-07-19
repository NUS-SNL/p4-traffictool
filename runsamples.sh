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

# for running in debug mode
yes n|./p4-traffictools.sh -p4 samples/arp/arp.p4 --std p4-16 -o samples/arp/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/basic_tunnel/basic_tunnel.p4 --std p4-16 -o samples/basic_tunnel/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/dummy-for-dissector/dissector_dummy.p4 --std p4-14 -o samples/dummy-for-dissector/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/heavy_hitter/heavy_hitter.p4 --std p4-14 -o samples/heavy_hitter/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/ipv4/ipv4_forward.p4 --std p4-16 -o samples/ipv4_forward/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/mri/mri.p4 --std p4-16 -o samples/mri/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/simple_nat/simple_nat.p4 --std p4-14 -o samples/simple_nat/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/simple_router/simple_router.p4 --std p4-14 -o samples/simple_router/output --scapy --wireshark --moongen --pcpp --debug
yes n|./p4-traffictools.sh -p4 samples/src_routing/src_routing.p4 --std p4-16 -o samples/src_routing/output --scapy --wireshark --moongen --pcpp --debug

#example showing variable length fields
# ./p4-traffictools.sh -p4 samples/tlv_parsing/tlv_parsing.p4 --std p4-14 -o samples/tlv_parsing/output --scapy --wireshark --moongen --pcpp --debug


# for running without debug flag
yes n|./p4-traffictools.sh -p4 samples/arp/arp.p4 --std p4-16 -o samples/arp/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/basic_tunnel/basic_tunnel.p4 --std p4-16 -o samples/basic_tunnel/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/dummy-for-dissector/dissector_dummy.p4 --std p4-14 -o samples/dummy-for-dissector/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/heavy_hitter/heavy_hitter.p4 --std p4-14 -o samples/heavy_hitter/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/ipv4/ipv4_forward.p4 --std p4-16 -o samples/ipv4_forward/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/mri/mri.p4 --std p4-16 -o samples/mri/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/simple_nat/simple_nat.p4 --std p4-14 -o samples/simple_nat/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/simple_router/simple_router.p4 --std p4-14 -o samples/simple_router/output --scapy --wireshark --moongen --pcpp 
yes n|./p4-traffictools.sh -p4 samples/src_routing/src_routing.p4 --std p4-16 -o samples/src_routing/output --scapy --wireshark --moongen --pcpp 

# example showing variable length fields
./p4-traffictools.sh -p4 samples/tlv_parsing/tlv_parsing.p4 --std p4-14 -o samples/tlv_parsing/output --scapy --wireshark --moongen --pcpp 
