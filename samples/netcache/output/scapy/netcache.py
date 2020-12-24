from scapy.all import *

##class definitions
class Nc_hdr(Packet):
    name = 'nc_hdr'
    fields_desc = [
        XByteField('op', 0),
        XLongField('key', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.op == 0x01):
            return Parse_value
        elif (self.op == 0x02):
            return Nc_load
        elif (self.op == 0x09):
            return Parse_value
        else:
            return Packet.guess_payload_class(self, payload)

class Nc_load(Packet):
    name = 'nc_load'
    fields_desc = [
        XIntField('load_1', 0),
        XIntField('load_2', 0),
        XIntField('load_3', 0),
        XIntField('load_4', 0),
    ]
    #update hdrChecksum over [['ipv4', 'version'], ['ipv4', 'ihl'], ['ipv4', 'diffserv'], ['ipv4', 'totalLen'], ['ipv4', 'identification'], ['ipv4', 'flags'], ['ipv4', 'fragOffset'], ['ipv4', 'ttl'], ['ipv4', 'protocol'], ['ipv4', 'srcAddr'], ['ipv4', 'dstAddr']] using csum16 in post_build method

class Nc_value_1(Packet):
    name = 'nc_value_1'
    fields_desc = [
        XIntField('value_1_1', 0),
        XIntField('value_1_2', 0),
        XIntField('value_1_3', 0),
        XIntField('value_1_4', 0),
    ]
class Nc_value_2(Packet):
    name = 'nc_value_2'
    fields_desc = [
        XIntField('value_2_1', 0),
        XIntField('value_2_2', 0),
        XIntField('value_2_3', 0),
        XIntField('value_2_4', 0),
    ]
class Nc_value_3(Packet):
    name = 'nc_value_3'
    fields_desc = [
        XIntField('value_3_1', 0),
        XIntField('value_3_2', 0),
        XIntField('value_3_3', 0),
        XIntField('value_3_4', 0),
    ]
class Nc_value_4(Packet):
    name = 'nc_value_4'
    fields_desc = [
        XIntField('value_4_1', 0),
        XIntField('value_4_2', 0),
        XIntField('value_4_3', 0),
        XIntField('value_4_4', 0),
    ]
class Nc_value_5(Packet):
    name = 'nc_value_5'
    fields_desc = [
        XIntField('value_5_1', 0),
        XIntField('value_5_2', 0),
        XIntField('value_5_3', 0),
        XIntField('value_5_4', 0),
    ]
class Nc_value_6(Packet):
    name = 'nc_value_6'
    fields_desc = [
        XIntField('value_6_1', 0),
        XIntField('value_6_2', 0),
        XIntField('value_6_3', 0),
        XIntField('value_6_4', 0),
    ]
class Nc_value_7(Packet):
    name = 'nc_value_7'
    fields_desc = [
        XIntField('value_7_1', 0),
        XIntField('value_7_2', 0),
        XIntField('value_7_3', 0),
        XIntField('value_7_4', 0),
    ]
class Nc_value_8(Packet):
    name = 'nc_value_8'
    fields_desc = [
        XIntField('value_8_1', 0),
        XIntField('value_8_2', 0),
        XIntField('value_8_3', 0),
        XIntField('value_8_4', 0),
    ]

## remaining bindings
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, TCP, proto=0x06)
bind_layers(IP, UDP, proto=0x11)
bind_layers(UDP, Nc_hdr, dport=0x22b8)

##packet_list

#No possible packets which can be parsed to the final state