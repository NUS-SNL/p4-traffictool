#!/bin/bash

# test cases picked from https://github.com/jafingerhut/p4lang-tests and https://github.com/p4lang/tutorials

declare -a src=("samples/arp/arp.p4" "samples/basic_tunnel/basic_tunnel.p4" "samples/simple_router/simple_router.p4" "samples/simple_router/simple_router.p4" "samples/ipv4/ipv4_forward.p4" "samples/heavy_hitter/heavy_hitter.p4" "samples/dummy-for-dissector/dissector_dummy.p4" "samples/src_routing/src_routing.p4" "samples/simple_nat/simple_nat.p4" "samples/tlv_parsing/tlv_parsing.p4" "samples/mri/mri.p4" "samples/arp/arp.p4")  
declare -a dst=("samples/arp/arp.json" "samples/basic_tunnel/basic_tunnel.json" "samples/simple_router/simple_router.json" "samples/simple_router/simple_router.json" "samples/ipv4/ipv4_forward.json" "samples/heavy_hitter/heavy_hitter.json" "samples/dummy-for-dissector/dissector_dummy.json" "samples/src_routing/src_routing.json" "samples/simple_nat/simple_nat.json" "samples/tlv_parsing/tlv_parsing.json" "samples/mri/mri.json" "samples/arp/arp.json")  

len=${#src[@]}

for ((i=0; i<${len}; i++));
do 
    
    if p4c-bmv2 --json ${dst[$i]} ${src[$i]};then
        echo "*****bmv2 worked******"
    else
        p4c -o ${dst[$i]} ${src[$i]}    
    fi
done

p4c-bmv2 tests/arp/arp.p4
p4c-bmv2 tests/basic_tunnel/basic_tunnel.p4
p4c-bmv2 tests/dummy-for-dissector/dissector_dummy.p4
p4c-bmv2 tests/heavy_hitter/heavy_hitter.p4
p4c-bmv2 tests/ipv4/ipv4_forward.p4
p4c-bmv2 tests/mri/mri.p4
p4c-bmv2 tests/simple_nat/simple_nat.p4
p4c-bmv2 tests/simple_router/simple_router.p4
p4c-bmv2 tests/tlv_parsing/tlv_parsing.p4