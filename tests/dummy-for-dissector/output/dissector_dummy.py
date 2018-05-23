from scapy import *

 ##class definitions
class Q_meta(Packet):
	name = 'q_meta'
	fields_desc = [
		BitField('flow_id',0,16),
		BitField('_pad0',0,16),
		BitField('ingress_global_tstamp',0,48),
		BitField('_pad1',0,16),
		BitField('egress_global_tstamp',0,48),
		BitField('_spare_pad_bits',0,15),
		BitField('markbit',0,1),
		BitField('_pad2',0,13),
		BitField('enq_qdepth',0,19),
		BitField('_pad3',0,13),
		BitField('_pad3',0,13)
	]

class Snapshot(Packet):
	name = 'snapshot'
	fields_desc = [
		BitField('ingress_global_tstamp_hi_16',0,16),
		BitField('ingress_global_tstamp_lo_32',0,32),
		BitField('egress_global_tstamp_lo_32',0,32),
		BitField('enq_qdepth',0,32),
		BitField('deq_qdepth',0,32),
		BitField('_pad0',0,16),
		BitField('orig_egress_global_tstamp',0,48),
		BitField('_pad1',0,16),
		BitField('new_egress_global_tstamp',0,48),
		BitField('new_egress_global_tstamp',0,48)
	]


##bindings
bind_layers(Ether, IP, etherType = 0x0800)
bind_layers(IP, UDP, protocol = 0x11)
bind_layers(UDP, Q_meta, dstPort = 0x1e61)
bind_layers(UDP, Snapshot, dstPort = 0x22b8)

##packet_list
_possible_packets_ = [
	(Ether()/IP()/UDP()/Q_meta()),
	(Ether()/IP()/UDP()),
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/UDP()/Snapshot())
]
