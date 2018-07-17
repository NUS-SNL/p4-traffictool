from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField(dstAddr, 0, 48),
		XBitField(srcAddr, 0, 48),
		ShortField(etherType, 0),
	]
class MyTunnel(Packet):
	name = 'myTunnel'
	fields_desc = [
		ShortField(proto_id, 0),
		ShortField(dst_id, 0),
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


##bindings
bind_layers(Ethernet, MyTunnel, etherType = 0x1212)
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(MyTunnel, Ipv4, proto_id = 0x0800)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/MyTunnel()),
	(Ethernet()/MyTunnel()/Ipv4())
]
