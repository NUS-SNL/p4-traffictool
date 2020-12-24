from scapy.all import *

##class definitions
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
bind_layers(Ether, SrcRoutes, type=0x1234)

##packet_list
possible_packets_ = [
    (Ether()),
    (Ether()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
    (Ether()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP())
]
