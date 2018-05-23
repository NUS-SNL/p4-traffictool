from scapy import *

 ##class definitions
class Ethernet(Packet):
	name = 'ethernet'
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
		BitField('srcAddr',0,32)
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		BitField('ingress_port',0,9),
		BitField('egress_spec',0,9),
		BitField('egress_port',0,9),
		BitField('clone_spec',0,32),
		BitField('instance_type',0,32),
		BitField('drop',0,1),
		BitField('recirculate_port',0,16),
		BitField('packet_length',0,32),
		BitField('enq_timestamp',0,32),
		BitField('enq_qdepth',0,19),
		BitField('deq_timedelta',0,32),
		BitField('deq_qdepth',0,19),
		BitField('ingress_global_timestamp',0,48),
		BitField('egress_global_timestamp',0,48),
		BitField('lf_field_list',0,32),
		BitField('mcast_grp',0,16),
		BitField('resubmit_flag',0,32),
		BitField('egress_rid',0,16),
		BitField('checksum_error',0,1),
		BitField('recirculate_flag',0,32),
		BitField('recirculate_flag',0,32)
	]
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method


##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)

##packet_list
_possible_packets_ = [
	(Ethernet()),
	(Ethernet()/Ipv4())
]
