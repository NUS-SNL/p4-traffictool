### Test Script for Moongen
* Bind one port to dpdk and leave one to igb_uio.
* Modify line 40 to set appropriate name for `getTestPacket` function depending on your requirements
* Start listening with `tcpdump` on igb_uio port
* Fire up moongen_packet_gen.lua as:
```
	sudo build/MoonGen moongen_packet_gen.lua <dpdk port number (0/1)> [-r rate in Mbits/s]
```

### Test Script for Scapy
* Copy the file to directory containing generated file containing Scapy code
* Insert name of the file in imports for this script
* Run the script to get an output of packets sent in parsable string form as well as packets in pcap format.
