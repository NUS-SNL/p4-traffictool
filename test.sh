#!/bin/bash
python src/GenTraffic.py tests/dummy-for-dissector/dissector_dummy.json tests/dummy-for-dissector/output/dissector_dummy.py
python src/GenTraffic.py tests/arp/arp.json tests/arp/output/arp.py
python src/GenTraffic.py tests/ipv4/ipv4_forward.json tests/ipv4/output/ipv4.py
python src/GenTraffic.py tests/mri/mri.json tests//output/mri.py
python src/GenTraffic.py tests/simple_router/simple_router.json tests/simple_router/output/simple_router.py

