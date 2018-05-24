from scapy.all import *

##class definitions
class Cpu_header(Packet):
	name = 'cpu_header'
	fields_desc = [
		BitField('preamble',0,64),
		BitField('device',0,8),
		BitField('reason',0,8),
		BitField('if_index',0,8)
	]
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
		BitField('res',0,4),
		BitField('flags',0,8),
		BitField('window',0,16),
		BitField('checksum',0,16),
		BitField('urgentPtr',0,16)
	]
	#update checksum over [[u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr'], u'0x00', [u'ipv4', u'protocol'], [u'meta', u'tcpLength'], [u'tcp', u'srcPort'], [u'tcp', u'dstPort'], [u'tcp', u'seqNo'], [u'tcp', u'ackNo'], [u'tcp', u'dataOffset'], [u'tcp', u'res'], [u'tcp', u'flags'], [u'tcp', u'window'], [u'tcp', u'urgentPtr'], u'payload'] using csum16 in post_build method


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
