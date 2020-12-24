from scapy.all import *

##class definitions
class Nc_hdr(Packet):
    name = 'nc_hdr'
    fields_desc = [
        XByteField('op', 0),
        XByteField('sc', 0),
        XShortField('seq', 0),
        XLongField('key', 0),
        XLongField('value', 0),
        XShortField('vgroup', 0),
    ]
class Overlay(Packet):
    name = 'overlay'
    fields_desc = [
        XIntField('swip', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.swip == 0x00000000):
            return Nc_hdr
        elif (self.swip == 0xfault):
            return Overlay
        else:
            return Packet.guess_payload_class(self, payload)


## remaining bindings
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, TCP, proto=0x06)
bind_layers(IP, UDP, proto=0x11)
bind_layers(UDP, Overlay, dport=0x22b8)
bind_layers(UDP, Overlay, dport=0x22b9)

##packet_list

#No possible packets which can be parsed to the final state