from scapy.all import *

##class definitions
class Hula(Packet):
    name = 'hula'
    fields_desc = [
        XBitField('_pad0', 0, 7),
        XBitField('dir', 0, 1),
        XBitField('_pad1', 0, 1),
        XBitField('qdepth', 0, 15),
        XIntField('digest', 0),
    ]
    #update hdrChecksum over [['ipv4', 'version'], ['ipv4', 'ihl'], ['ipv4', 'diffserv'], ['ipv4', 'totalLen'], ['ipv4', 'identification'], ['ipv4', 'flags'], ['ipv4', 'fragOffset'], ['ipv4', 'ttl'], ['ipv4', 'protocol'], ['ipv4', 'srcAddr'], ['ipv4', 'dstAddr']] using csum16 in post_build method

class SrcRoutes(Packet):
    name = 'srcRoutes'
    fields_desc = [
        XBitField('_pad0', 0, 7),
        XBitField('bos', 0, 1),
        XBitField('_pad1', 0, 1),
        XBitField('port', 0, 15),
    ]

    def guess_payload_class(self, payload):
        if (self.bos == 0x01):
            return Ip
        elif (self.bos == 0xfa):
            return Srcroutes
        else:
            return Packet.guess_payload_class(self, payload)


## remaining bindings
bind_layers(Ether, Hula, type=0x2345)
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, UDP, proto=0x11)

##packet_list
possible_packets_ = [
    (Ether()),
    (Ether()/IP()),
    (Ether()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
    (Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP())
]
