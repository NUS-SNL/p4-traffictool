from scapy.all import *

##class definitions

##bindings
bind_layers(Ether, IP, type = 0x0800)
bind_layers(IP, TCP, proto = 0x06)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/TCP())
]
