#!/bin/bash
python src/GenTraffic.py samples/arp/arp.json samples/arp/output/arp.py
python src/GenTraffic.py samples/basic_tunnel/basic_tunnel.json samples/basic_tunnel/output/basic_tunnel.py
python src/GenTraffic.py samples/dummy-for-dissector/dissector_dummy.json samples/dummy-for-dissector/output/dissector_dummy.py
python src/GenTraffic.py samples/heavy_hitter/heavy_hitter.json samples/heavy_hitter/output/heavy_hitter.py
python src/GenTraffic.py samples/ipv4/ipv4_forward.json samples/ipv4/output/ipv4.py
python src/GenTraffic.py samples/mri/mri.json samples/mri/output/mri.py
python src/GenTraffic.py samples/simple_nat/simple_nat.json samples/simple_nat/output/simple_nat.py
python src/GenTraffic.py samples/simple_router/simple_router.json samples/simple_router/output/simple_router.py
python src/GenTraffic.py samples/src_routing/src_routing.json samples/src_routing/output/src_routing.py
# python src/GenTraffic.py samples/tlv_parsing/tlv_parsing.json samples/tlv_parsing/output/tlv_parsing.py

# test cases picked from https://github.com/jafingerhut/p4lang-samples and https://github.com/p4lang/tutorials