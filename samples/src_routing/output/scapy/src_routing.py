from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField(dstAddr, 0, 48),
		XBitField(srcAddr, 0, 48),
		ShortField(etherType, 0),
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
class SrcRoutes_0(Packet):
	name = 'srcRoutes[0]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_1(Packet):
	name = 'srcRoutes[1]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_2(Packet):
	name = 'srcRoutes[2]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_3(Packet):
	name = 'srcRoutes[3]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_4(Packet):
	name = 'srcRoutes[4]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_5(Packet):
	name = 'srcRoutes[5]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_6(Packet):
	name = 'srcRoutes[6]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_7(Packet):
	name = 'srcRoutes[7]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]
class SrcRoutes_8(Packet):
	name = 'srcRoutes[8]'
	fields_desc = [
		XBitField(bos, 0, 1),
		XBitField(port, 0, 15),
	]

##bindings

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/SrcRoutes_0()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/SrcRoutes_3()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/SrcRoutes_3()/SrcRoutes_4()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/SrcRoutes_3()/SrcRoutes_4()/SrcRoutes_5()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/SrcRoutes_3()/SrcRoutes_4()/SrcRoutes_5()/SrcRoutes_6()/Ipv4()),
	(Ethernet()/SrcRoutes_0()/SrcRoutes_1()/SrcRoutes_2()/SrcRoutes_3()/SrcRoutes_4()/SrcRoutes_5()/SrcRoutes_6()/SrcRoutes_7()/Ipv4())
]
