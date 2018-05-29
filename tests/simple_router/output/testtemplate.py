from simple_router import *

for i in xrange(10):
	for j in possible_packets:
		wrpcap('packetfile.pcap',j/"XXX",append=True)