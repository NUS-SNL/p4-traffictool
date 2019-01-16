from scapy.all import *

##class definitions
class MyTunnel(Packet):
	name = 'myTunnel'
	fields_desc = [
		XShortField('proto_id', 0),
		XShortField('dst_id', 0),
	]

##bindings
bind_layers(Ether, MyTunnel, type = 0x1212)
bind_layers(Ether, IP, type = 0x0800)
bind_layers(MyTunnel, IP, proto_id = 0x0800)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/MyTunnel()),
	(Ether()/MyTunnel()/IP())
]
