#!/usr/bin/python

from scapy.all import *
from arp import *
import os

os.system("rm -rf raw_dump.pcap")

for packet in possible_packets_:
	wrpcap("raw_dump.pcap", packet/"XXX", append=True)
	packet.show()
