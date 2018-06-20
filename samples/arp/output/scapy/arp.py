from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr',0,48),
		XBitField('srcAddr',0,48),
		XBitField('etherType',0,16)
	]
class Arp(Packet):
	name = 'arp'
	fields_desc = [
		XBitField('htype',0,16),
		XBitField('ptype',0,16),
		XBitField('hlen',0,8),
		XBitField('plen',0,8),
		XBitField('oper',0,16)
	]
class Arp_ipv4(Packet):
	name = 'arp_ipv4'
	fields_desc = [
		XBitField('sha',0,48),
		XBitField('spa',0,32),
		XBitField('tha',0,48),
		XBitField('tpa',0,32)
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		XBitField('version',0,4),
		XBitField('ihl',0,4),
		XBitField('diffserv',0,8),
		XBitField('totalLen',0,16),
		XBitField('identification',0,16),
		XBitField('flags',0,3),
		XBitField('fragOffset',0,13),
		XBitField('ttl',0,8),
		XBitField('protocol',0,8),
		XBitField('hdrChecksum',0,16),
		XBitField('srcAddr',0,32),
		XBitField('dstAddr',0,32)
	]
class Icmp(Packet):
	name = 'icmp'
	fields_desc = [
		XBitField('type',0,8),
		XBitField('code',0,8),
		XBitField('checksum',0,16)
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ethernet, Arp, etherType = 0x0806)
bind_layers(Arp, Arp_ipv4, htype = 0x000108000604)
bind_layers(Ipv4, Icmp, protocol = 0x01)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Arp()),
	(Ethernet()/Arp()/Arp_ipv4()),
	(Ethernet()/Ipv4()/Icmp())
]
