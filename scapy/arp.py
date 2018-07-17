from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField(dstAddr, 0, 48),
		XBitField(srcAddr, 0, 48),
		ShortField(etherType, 0),
	]
class Arp(Packet):
	name = 'arp'
	fields_desc = [
		ShortField(htype, 0),
		ShortField(ptype, 0),
		ByteField(hlen, 0),
		ByteField(plen, 0),
		ShortField(oper, 0),
	]
class Arp_ipv4(Packet):
	name = 'arp_ipv4'
	fields_desc = [
		XBitField(sha, 0, 48),
		IntField(spa, 0),
		XBitField(tha, 0, 48),
		IntField(tpa, 0),
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		XBitField(version, 0, 4),
		XBitField(ihl, 0, 4),
		ByteField(diffserv, 0),
		ShortField(totalLen, 0),
		ShortField(identification, 0),
		XBitField(flags, 0, 3),
		XBitField(fragOffset, 0, 13),
		ByteField(ttl, 0),
		ByteField(protocol, 0),
		ShortField(hdrChecksum, 0),
		IntField(srcAddr, 0),
		IntField(dstAddr, 0),
	]
class Icmp(Packet):
	name = 'icmp'
	fields_desc = [
		ByteField(type, 0),
		ByteField(code, 0),
		ShortField(checksum, 0),
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
