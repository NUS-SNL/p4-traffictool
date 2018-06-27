#!/bin/bash
mkdir samples/arp/output
mkdir samples/basic_tunnel/output
mkdir samples/dummy-for-dissector/output
mkdir samples/heavy_hitter/output
mkdir samples/ipv4/output
mkdir samples/mri/output
mkdir samples/simple_nat/output
mkdir samples/simple_router/output
mkdir samples/src_routing/output
mkdir samples/tlv_parsing/output

# ./p4-pktcodegen.sh samples/arp/arp.p4 p4-16 samples/arp/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/basic_tunnel/basic_tunnel.p4 p4-16 samples/basic_tunnel/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/dummy-for-dissector/dissector_dummy.p4 p4-14 samples/dummy-for-dissector/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/heavy_hitter/heavy_hitter.p4 p4-14 samples/heavy_hitter/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/ipv4/ipv4_forward.p4 p4-16 samples/ipv4/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/mri/mri.p4 p4-16 samples/mri/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/simple_nat/simple_nat.p4 p4-14 samples/simple_nat/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/simple_router/simple_router.p4 p4-14 samples/simple_router/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/src_routing/src_routing.p4 p4-16 samples/src_routing/output -scapy -lua -moongen -pcpp --d <responses
# ./p4-pktcodegen.sh samples/tlv_parsing/tlv_parsing.p4 p4-14 samples/tlv_parsing/output -scapy -lua -moongen -pcpp --d 

./p4-pktcodegen.sh samples/arp/arp.p4 p4-16 samples/arp/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/basic_tunnel/basic_tunnel.p4 p4-16 samples/basic_tunnel/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/dummy-for-dissector/dissector_dummy.p4 p4-14 samples/dummy-for-dissector/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/heavy_hitter/heavy_hitter.p4 p4-14 samples/heavy_hitter/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/ipv4/ipv4_forward.p4 p4-16 samples/ipv4/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/mri/mri.p4 p4-16 samples/mri/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/simple_nat/simple_nat.p4 p4-14 samples/simple_nat/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/simple_router/simple_router.p4 p4-14 samples/simple_router/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/src_routing/src_routing.p4 p4-16 samples/src_routing/output -scapy -lua -moongen -pcpp  <responses
./p4-pktcodegen.sh samples/tlv_parsing/tlv_parsing.p4 p4-14 samples/tlv_parsing/output -scapy -lua -moongen -pcpp  
