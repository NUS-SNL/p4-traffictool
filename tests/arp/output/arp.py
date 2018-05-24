from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		BitField('dstAddr',0,48),
		BitField('srcAddr',0,48),
		BitField('etherType',0,16)
	]
class Arp(Packet):
	name = 'arp'
	fields_desc = [
		BitField('htype',0,16),
		BitField('ptype',0,16),
		BitField('hlen',0,8),
		BitField('plen',0,8),
		BitField('oper',0,16)
	]
class Arp_ipv4(Packet):
	name = 'arp_ipv4'
	fields_desc = [
		BitField('sha',0,48),
		BitField('spa',0,32),
		BitField('tha',0,48),
		BitField('tpa',0,32)
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		BitField('version',0,4),
		BitField('ihl',0,4),
		BitField('diffserv',0,8),
		BitField('totalLen',0,16),
		BitField('identification',0,16),
		BitField('flags',0,3),
		BitField('fragOffset',0,13),
		BitField('ttl',0,8),
		BitField('protocol',0,8),
		BitField('hdrChecksum',0,16),
		BitField('srcAddr',0,32),
		BitField('dstAddr',0,32)
	]
class Icmp(Packet):
	name = 'icmp'
	fields_desc = [
		BitField('type',0,8),
		BitField('code',0,8),
		BitField('checksum',0,16)
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
