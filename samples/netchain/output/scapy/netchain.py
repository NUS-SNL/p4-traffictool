from scapy.all import *

##class definitions
class Overlay(Packet):
	name = 'overlay'
	fields_desc = [
		XIntField('swip', 0),
	]
class Nc_hdr(Packet):
	name = 'nc_hdr'
	fields_desc = [
		XByteField('op', 0),
		XByteField('sc', 0),
		XShortField('seq', 0),
		XLongField('key', 0),
		XLongField('value', 0),
		XShortField('vgroup', 0),
	]

##bindings
bind_layers(Ether, IP, type = 0x0800)
bind_layers(IP, TCP, proto = 0x06)
bind_layers(IP, UDP, proto = 0x11)
bind_layers(Overlay, Nc_hdr, swip = 0x00000000)
bind_layers(Overlay,Overlay)
bind_layers(UDP, Overlay, dport = 0x22b8)
bind_layers(UDP, Overlay, dport = 0x22b9)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/UDP()),
	(Ether()/IP()/TCP()),
	(Ether()/IP()/UDP()/Overlay()/Nc_hdr()),
	(Ether()/IP()/UDP()/Overlay()/Overlay()/Nc_hdr()),
	(Ether()/IP()/UDP()/Overlay()/Overlay()/Overlay()/Nc_hdr()),
	(Ether()/IP()/UDP()/Overlay()/Overlay()/Overlay()/Overlay()/Nc_hdr()),
	(Ether()/IP()/UDP()/Overlay()/Overlay()/Overlay()/Overlay()/Overlay()/Nc_hdr())
]
