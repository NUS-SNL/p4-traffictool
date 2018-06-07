   #!/bin/bash
# python src/GenTraffic.py tests/arp/arp.json tests/arp/output/arp.py
# python src/GenTraffic.py tests/basic_tunnel/basic_tunnel.json tests/basic_tunnel/output/basic_tunnel.py
# python src/GenTraffic.py tests/dummy-for-dissector/dissector_dummy.json tests/dummy-for-dissector/output/dissector_dummy.py
# python src/GenTraffic.py tests/heavy_hitter/heavy_hitter.json tests/heavy_hitter/output/heavy_hitter.py
# python src/GenTraffic.py tests/ipv4/ipv4_forward.json tests/ipv4/output/ipv4.py
# python src/GenTraffic.py tests/mri/mri.json tests/mri/output/mri.py
# python src/GenTraffic.py tests/simple_nat/simple_nat.json tests/simple_nat/output/simple_nat.py
# python src/GenTraffic.py tests/simple_router/simple_router.json tests/simple_router/output/simple_router.py
# python src/GenTraffic.py tests/src_routing/src_routing.json tests/src_routing/output/src_routing.py
# # python src/GenTraffic.py tests/tlv_parsing/tlv_parsing.json tests/tlv_parsing/output/tlv_parsing.py

# test cases picked from https://github.com/jafingerhut/p4lang-tests and https://github.com/p4lang/tutorials
p4c-bmv2 tests/arp/arp.p4
p4c-bmv2 tests/basic_tunnel/basic_tunnel.p4
p4c-bmv2 tests/dummy-for-dissector/dissector_dummy.p4
p4c-bmv2 tests/heavy_hitter/heavy_hitter.p4
p4c-bmv2 tests/ipv4/ipv4_forward.p4
p4c-bmv2 tests/mri/mri.p4
p4c-bmv2 tests/simple_nat/simple_nat.p4
p4c-bmv2 tests/simple_router/simple_router.p4
p4c-bmv2 tests/tlv_parsing/tlv_parsing.p4
