from scapy.all import *

##class definitions
class Ipv4_option(Packet):
    name = 'ipv4_option'
    fields_desc = [
        XBitField('_pad0', 0, 7),
        XBitField('copyFlag', 0, 1),
        XBitField('_pad1', 0, 6),
        XBitField('optClass', 0, 2),
        XBitField('_pad2', 0, 3),
        XBitField('option', 0, 5),
        XByteField('optionLength', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.option == 0x1f):
            return Mri
        else:
            return Packet.guess_payload_class(self, payload)

class Mri(Packet):
    name = 'mri'
    fields_desc = [
        XShortField('count', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.count == 0xfaul):
            return Swids
        else:
            return Packet.guess_payload_class(self, payload)

    #update hdrChecksum over [['ipv4', 'version'], ['ipv4', 'ihl'], ['ipv4', 'diffserv'], ['ipv4', 'totalLen'], ['ipv4', 'identification'], ['ipv4', 'flags'], ['ipv4', 'fragOffset'], ['ipv4', 'ttl'], ['ipv4', 'protocol'], ['ipv4', 'srcAddr'], ['ipv4', 'dstAddr']] using csum16 in post_build method

class Swids(Packet):
    name = 'swids'
    fields_desc = [
        XIntField('swid', 0),
    ]

    def guess_payload_class(self, payload):
        