from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr', 0, 48),
		XBitField('srcAddr', 0, 48),
		XShortField('etherType', 0),
	]
class Arp(Packet):
	name = 'arp'
	fields_desc = [
		XShortField('htype', 0),
		XShortField('ptype', 0),
		XByteField('hlen', 0),
		XByteField('plen', 0),
		XShortField('oper', 0),
	]
class Arp_ipv4(Packet):
	name = 'arp_ipv4'
	fields_desc = [
		XBitField('sha', 0, 48),
		XLongField('spa', 0),
		XBitField('tha', 0, 48),
		XLongField('tpa', 0),
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		XBitField('version', 0, 4),
		XBitField('ihl', 0, 4),
		XByteField('diffserv', 0),
		XShortField('totalLen', 0),
		XShortField('identification', 0),
		XBitField('flags', 0, 3),
		XBitField('fragOffset', 0, 13),
		XByteField('ttl', 0),
		XByteField('protocol', 0),
		XShortField('hdrChecksum', 0),
		XLongField('srcAddr', 0),
		XLongField('dstAddr', 0),
	]
class Icmp(Packet):
	name = 'icmp'
	fields_desc = [
		XByteField('type', 0),
		XByteField('code', 0),
		XShortField('checksum', 0),
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ethernet, Arp, etherType = 0x0806)
bind_layers(Arp, Arp_ipv4, htype = 0x000108000604)
bind_layers(Ipv4, Icmp, protocol = 0x01)

##packet_list
possible_packets_ = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Arp()),
	(Ethernet()/Arp()/Arp_ipv4()),
	(Ethernet()/Ipv4()/Icmp())
]
