from scapy.all import *

##class definitions
class Q_meta(Packet):
    name = 'q_meta'
    fields_desc = [
        XShortField('flow_id', 0),
        XShortField('_pad0', 0),
        XBitField('ingress_global_tstamp', 0, 48),
        XShortField('_pad1', 0),
        XBitField('egress_global_tstamp', 0, 48),
        XBitField('_pad2', 0, 15),
        XBitField('markbit', 0, 1),
        XBitField('_pad3', 0, 5),
        XBitField('enq_qdepth', 0, 19),
        XBitField('_pad4', 0, 5),
        XBitField('deq_qdepth', 0, 19),
    ]
class Snapshot(Packet):
    name = 'snapshot'
    fields_desc = [
        XShortField('ingress_global_tstamp_hi_16', 0),
        XIntField('ingress_global_tstamp_lo_32', 0),
        XIntField('egress_global_tstamp_lo_32', 0),
        XIntField('enq_qdepth', 0),
        XIntField('deq_qdepth', 0),
        XShortField('_pad0', 0),
        XBitField('orig_egress_global_tstamp', 0, 48),
        XShortField('_pad1', 0),
        XBitField('new_egress_global_tstamp', 0, 48),
        XIntField('new_enq_tstamp', 0),
    ]
    #update hdrChecksum over [['ipv4', 'version'], ['ipv4', 'ihl'], ['ipv4', 'diffserv'], ['ipv4', 'totalLen'], ['ipv4', 'identification'], ['ipv4', 'flags'], ['ipv4', 'fragOffset'], ['ipv4', 'ttl'], ['ipv4', 'protocol'], ['ipv4', 'srcAddr'], ['ipv4', 'dstAddr']] using csum16 in post_build method


## remaining bindings
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, UDP, proto=0x11)
bind_layers(UDP, Q_meta, dport=0x1e61)
bind_layers(UDP, Snapshot, dport=0x22b8)

##packet_list

#No possible packets which can be parsed to the final state