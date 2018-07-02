from scapy.all import *

##class definitions
class Cpu_header(Packet):
	name = 'cpu_header'
	fields_desc = [
		XBitField('preamble',0,64),
		XBitField('device',0,8),
		XBitField('reason',0,8),
		XBitField('if_index',0,8)
	]
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr',0,48),
		XBitField('srcAddr',0,48),
		XBitField('etherType',0,16)
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
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Tcp(Packet):
	name = 'tcp'
	fields_desc = [
		XBitField('srcPort',0,16),
		XBitField('dstPort',0,16),
		XBitField('seqNo',0,32),
		XBitField('ackNo',0,32),
		XBitField('dataOffset',0,4),
		XBitField('res',0,4),
		XBitField('flags',0,8),
		XBitField('window',0,16),
		XBitField('checksum',0,16),
		XBitField('urgentPtr',0,16)
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
