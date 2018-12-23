from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr', 0, 48),
		XBitField('srcAddr', 0, 48),
		XShortField('etherType', 0),
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
		XIntField('srcAddr', 0),
		XIntField('dstAddr', 0),
	]
class Tcp(Packet):
	name = 'tcp'
	fields_desc = [
		XShortField('srcPort', 0),
		XShortField('dstPort', 0),
		XIntField('seqNo', 0),
		XIntField('ackNo', 0),
		XBitField('dataOffset', 0, 4),
		XBitField('res', 0, 3),
		XBitField('ecn', 0, 3),
		XBitField('ctrl', 0, 6),
		XShortField('window', 0),
		XShortField('checksum', 0),
		XShortField('urgentPtr', 0),
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Tcp, protocol = 0x06)

##packet_list
possible_packets_ = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Tcp())
]
