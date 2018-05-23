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
		BitField('copyFlag',0,1),
		BitField('optClass',0,2),
		BitField('option',0,5),
		BitField('option',0,5)
	]

class Ipv4_option(Packet):
	name = 'ipv4_option'
	fields_desc = [
		BitField('option',0,5)
	]

class Mri(Packet):
	name = 'mri'
	fields_desc = [
		BitField('option',0,5)
	]

class Swids[0](Packet):
	name = 'swids[0]'
	fields_desc = [
		BitField('option',0,5)
	]

class Swids[1](Packet):
	name = 'swids[1]'
	fields_desc = [
		BitField('option',0,5)
	]

class Swids[2](Packet):
	name = 'swids[2]'
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


##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Ipv4_option, ihl = default)
bind_layers(Ipv4_option, Mri, option = 0x1f)

##packet_list
_possible_packets_ = [
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()),
	(Ethernet())
]
