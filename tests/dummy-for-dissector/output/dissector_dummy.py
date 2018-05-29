from scapy.all import *
import random

##class definitions
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

class Udp(Packet):
	name = 'udp'
	fields_desc = [
		XBitField('srcPort',0,16),
		XBitField('dstPort',0,16),
		XBitField('hdr_length',0,16),
		XBitField('checksum',0,16)
	]
class Q_meta(Packet):
	name = 'q_meta'
	fields_desc = [
		XBitField('flow_id',0,16),
		XBitField('_pad0',0,16),
		XBitField('ingress_global_tstamp',0,48),
		XBitField('_pad1',0,16),
		XBitField('egress_global_tstamp',0,48),
		XBitField('_spare_pad_bits',0,15),
		XBitField('markbit',0,1),
		XBitField('_pad2',0,13),
		XBitField('enq_qdepth',0,19),
		XBitField('_pad3',0,13),
		XBitField('deq_qdepth',0,19)
	]
class Snapshot(Packet):
	name = 'snapshot'
	fields_desc = [
		XBitField('ingress_global_tstamp_hi_16',0,16),
		XBitField('ingress_global_tstamp_lo_32',0,32),
		XBitField('egress_global_tstamp_lo_32',0,32),
		XBitField('enq_qdepth',0,32),
		XBitField('deq_qdepth',0,32),
		XBitField('_pad0',0,16),
		XBitField('orig_egress_global_tstamp',0,48),
		XBitField('_pad1',0,16),
		XBitField('new_egress_global_tstamp',0,48),
		XBitField('new_enq_tstamp',0,32)
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Udp, protocol = 0x11)
bind_layers(Udp, Q_meta, dstPort = 0x1e61)
bind_layers(Udp, Snapshot, dstPort = 0x22b8)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4(version = 0x4)),
	(Ethernet()/Ipv4(version = 0x4)/Udp()),
	(Ethernet()/Ipv4(version = 0x4)/Udp()/Q_meta(egress_global_tstamp = 40)),
	(Ethernet()/Ipv4(version = 0x4)/Udp()/Snapshot())
]
