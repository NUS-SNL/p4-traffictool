from scapy.all import *

##class definitions
class MyTunnel(Packet):
    name = 'myTunnel'
    fields_desc = [
        XShortField('proto_id', 0),
        XShortField('dst_id', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.proto_id == 0x0800):
            return Ip
        else:
            return Packet.guess_payload_class(self, payload)


## remaining bindings
bind_layers(Ether, MyTunnel, type=0x1212)
bind_layers(Ether, IP, type=0x0800)

##packet_list
possible_packets_ = [
    (Ether()),
    (Ether()/MyTunnel()),
    (Ether()/IP()),
    (Ether()/MyTunnel()/IP())
]
