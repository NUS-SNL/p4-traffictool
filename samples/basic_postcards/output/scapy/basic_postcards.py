from scapy.all import *

##class definitions
class Hdr_meta(Packet):
    name = 'hdr_meta'
    fields_desc = [
        XBitField('mac_dstAddr', 0, 48),
        XBitField('mac_srcAddr', 0, 48),
        XIntField('ip_srcAddr', 0),
        XIntField('ip_dstAddr', 0),
        XByteField('ip_protocol', 0),
    ]
class Q_meta(Packet):
    name = 'q_meta'
    fields_desc = [
        XBitField('enq_qdepth', 0, 24),
        XBitField('deq_qdepth', 0, 24),
        XIntField('deq_timedelta', 0),
        XIntField('enq_timestamp', 0),
    ]

## remaining bindings
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, UDP, proto=0x11)
bind_layers(UDP, Hdr_meta, dport=0x270f)

##packet_list
possible_packets_ = [
    (Ether()),
    (Ether()/IP()),
    (Ether()/IP()/UDP()),
    (Ether()/IP()/UDP()/Hdr_meta())
]
