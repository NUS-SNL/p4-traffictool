from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		BitField('dstAddr',0,48),
		BitField('srcAddr',0,48),
		BitField('etherType',0,16)
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
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Tcp(Packet):
	name = 'tcp'
	fields_desc = [
		BitField('srcPort',0,16),
		BitField('dstPort',0,16),
		BitField('seqNo',0,32),
		BitField('ackNo',0,32),
		BitField('dataOffset',0,4),
		BitField('res',0,3),
		BitField('ecn',0,3),
		BitField('ctrl',0,6),
		BitField('window',0,16),
		BitField('checksum',0,16),
		BitField('urgentPtr',0,16)
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Tcp, protocol = 0x06)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Tcp())
]
