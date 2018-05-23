from scapy import *

 ##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		BitField('htype',0,16),
		BitField('ptype',0,16),
		BitField('hlen',0,8),
		BitField('plen',0,8),
		BitField('plen',0,8)
	]

class Arp(Packet):
	name = 'arp'
	fields_desc = [
		BitField('sha',0,48),
		BitField('spa',0,32),
		BitField('tha',0,48),
		BitField('tha',0,48)
	]

class Arp_ipv4(Packet):
	name = 'arp_ipv4'
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
		BitField('type',0,8),
		BitField('code',0,8),
		BitField('code',0,8)
	]

class Icmp(Packet):
	name = 'icmp'
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
bind_layers(Ethernet, Arp, etherType = 0x0806)
bind_layers(Arp, Arp_ipv4, htype = 0x000108000604)
bind_layers(Ipv4, Icmp, protocol = 0x01)

##packet_list
_possible_packets_ = [
	(Ethernet()/Ipv4()/Icmp()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Arp()/Arp_ipv4()),
	(Ethernet()/Arp()),
	(Ethernet())
]
