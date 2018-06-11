#!/bin/bash
mkdir samples/arp/output/python
mkdir samples/basic_tunnel/output/python
mkdir samples/dummy-for-dissector/output/python
mkdir samples/heavy_hitter/output/python
mkdir samples/ipv4/output/python
mkdir samples/mri/output/python
mkdir samples/simple_nat/output/python
mkdir samples/simple_router/output/python
mkdir samples/src_routing/output/python
mkdir samples/tlv_parsing/output/python

mkdir samples/arp/output/lua
mkdir samples/basic_tunnel/output/lua
mkdir samples/dummy-for-dissector/output/lua
mkdir samples/heavy_hitter/output/lua
mkdir samples/ipv4/output/lua
mkdir samples/mri/output/lua
mkdir samples/simple_nat/output/lua
mkdir samples/simple_router/output/lua
mkdir samples/src_routing/output/lua
mkdir samples/tlv_parsing/output/lua


python src/GenTraffic.py samples/arp/arp.json samples/arp/output/python/arp.py
python src/GenTraffic.py samples/basic_tunnel/basic_tunnel.json samples/basic_tunnel/output/python/basic_tunnel.py
python src/GenTraffic.py samples/dummy-for-dissector/dissector_dummy.json samples/dummy-for-dissector/output/python/dissector_dummy.py
python src/GenTraffic.py samples/heavy_hitter/heavy_hitter.json samples/heavy_hitter/output/python/heavy_hitter.py
python src/GenTraffic.py samples/ipv4/ipv4_forward.json samples/ipv4/output/python/ipv4.py
python src/GenTraffic.py samples/mri/mri.json samples/mri/output/python/mri.py
python src/GenTraffic.py samples/simple_nat/simple_nat.json samples/simple_nat/output/python/simple_nat.py
python src/GenTraffic.py samples/simple_router/simple_router.json samples/simple_router/output/python/simple_router.py
python src/GenTraffic.py samples/src_routing/src_routing.json samples/src_routing/output/python/src_routing.py
python src/GenTraffic.py samples/tlv_parsing/tlv_parsing.json samples/tlv_parsing/output/python/tlv_parsing.py

python src/GenTrafficMoonGen.py samples/arp/arp.json samples/arp/output/lua
python src/GenTrafficMoonGen.py samples/basic_tunnel/basic_tunnel.json samples/basic_tunnel/output/lua
python src/GenTrafficMoonGen.py samples/dummy-for-dissector/dissector_dummy.json samples/dummy-for-dissector/output/lua
python src/GenTrafficMoonGen.py samples/heavy_hitter/heavy_hitter.json samples/heavy_hitter/output/lua
python src/GenTrafficMoonGen.py samples/ipv4/ipv4_forward.json samples/ipv4/output/lua
python src/GenTrafficMoonGen.py samples/mri/mri.json samples/mri/output/lua
python src/GenTrafficMoonGen.py samples/simple_nat/simple_nat.json samples/simple_nat/output/lua
python src/GenTrafficMoonGen.py samples/simple_router/simple_router.json samples/simple_router/output/lua
python src/GenTrafficMoonGen.py samples/src_routing/src_routing.json samples/src_routing/output/lua
python src/GenTrafficMoonGen.py samples/tlv_parsing/tlv_parsing.json samples/tlv_parsing/output/lua
# test cases picked from https://github.com/jafingerhut/p4lang-samples and https://github.com/p4lang/tutorials