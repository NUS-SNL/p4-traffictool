from scapy.all import *

##class definitions
class Cpu_header(Packet):
	name = 'cpu_header'
	fields_desc = [
		XBitField(preamble, 0, 64),
		ByteField(device, 0),
		ByteField(reason, 0),
		ByteField(if_index, 0),
	]
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
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Tcp(Packet):
	name = 'tcp'
	fields_desc = [
		ShortField(srcPort, 0),
		ShortField(dstPort, 0),
		IntField(seqNo, 0),
		IntField(ackNo, 0),
		XBitField(dataOffset, 0, 4),
		XBitField(res, 0, 4),
		ByteField(flags, 0),
		ShortField(window, 0),
		ShortField(checksum, 0),
		ShortField(urgentPtr, 0),
	]
	#update checksum over [[u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr'], u'0x00', [u'ipv4', u'protocol'], [u'meta', u'tcpLength'], [u'tcp', u'srcPort'], [u'tcp', u'dstPort'], [u'tcp', u'seqNo'], [u'tcp', u'ackNo'], [u'tcp', u'dataOffset'], [u'tcp', u'res'], [u'tcp', u'flags'], [u'tcp', u'window'], [u'tcp', u'urgentPtr'], None] using csum16 in post_build method


##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Tcp, protocol = 0x06)

##packet_list
possible_packets = [
	(Ethernet()),
	(Cpu_header()/Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Tcp()),
	(Cpu_header()/Ethernet()/Ipv4()),
	(Cpu_header()/Ethernet()/Ipv4()/Tcp())
]
