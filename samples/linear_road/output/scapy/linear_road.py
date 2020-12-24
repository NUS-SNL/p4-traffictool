from scapy.all import *

##class definitions
class Accident_alert(Packet):
    name = 'accident_alert'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XShortField('emit', 0),
        XByteField('seg', 0),
    ]
class Accnt_bal(Packet):
    name = 'accnt_bal'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XShortField('emit', 0),
        XIntField('qid', 0),
        XIntField('bal', 0),
    ]
class Accnt_bal_req(Packet):
    name = 'accnt_bal_req'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XIntField('qid', 0),
    ]
class Expenditure_report(Packet):
    name = 'expenditure_report'
    fields_desc = [
        XShortField('time', 0),
        XShortField('emit', 0),
        XIntField('qid', 0),
        XShortField('bal', 0),
    ]
class Expenditure_req(Packet):
    name = 'expenditure_req'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XIntField('qid', 0),
        XByteField('xway', 0),
        XByteField('day', 0),
    ]
class Lr_msg_type(Packet):
    name = 'lr_msg_type'
    fields_desc = [
        XByteField('msg_type', 0),
    ]

    def guess_payload_class(self, payload):
        if (self.msg_type == 0x00):
            return Pos_report
        elif (self.msg_type == 0x02):
            return Accnt_bal_req
        elif (self.msg_type == 0x0a):
            return Toll_notification
        elif (self.msg_type == 0x0b):
            return Accident_alert
        elif (self.msg_type == 0x0c):
            return Accnt_bal
        elif (self.msg_type == 0x03):
            return Expenditure_req
        elif (self.msg_type == 0x0d):
            return Expenditure_report
        elif (self.msg_type == 0x04):
            return Travel_estimate_req
        elif (self.msg_type == 0x0e):
            return Travel_estimate
        else:
            return Packet.guess_payload_class(self, payload)

class Pos_report(Packet):
    name = 'pos_report'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XByteField('spd', 0),
        XByteField('xway', 0),
        XByteField('lane', 0),
        XByteField('dir', 0),
        XByteField('seg', 0),
    ]
    #update hdrChecksum over [['ipv4', 'version'], ['ipv4', 'ihl'], ['ipv4', 'diffserv'], ['ipv4', 'totalLen'], ['ipv4', 'identification'], ['ipv4', 'flags'], ['ipv4', 'fragOffset'], ['ipv4', 'ttl'], ['ipv4', 'protocol'], ['ipv4', 'srcAddr'], ['ipv4', 'dstAddr']] using csum16 in post_build method

class Toll_notification(Packet):
    name = 'toll_notification'
    fields_desc = [
        XShortField('time', 0),
        XIntField('vid', 0),
        XShortField('emit', 0),
        XByteField('spd', 0),
        XShortField('toll', 0),
    ]
class Travel_estimate(Packet):
    name = 'travel_estimate'
    fields_desc = [
        XIntField('qid', 0),
        XShortField('travel_time', 0),
        XShortField('toll', 0),
    ]
class Travel_estimate_req(Packet):
    name = 'travel_estimate_req'
    fields_desc = [
        XShortField('time', 0),
        XIntField('qid', 0),
        XByteField('xway', 0),
        XByteField('seg_init', 0),
        XByteField('seg_end', 0),
        XByteField('dow', 0),
        XByteField('tod', 0),
    ]

## remaining bindings
bind_layers(Ether, IP, type=0x0800)
bind_layers(IP, UDP, proto=0x11)
bind_layers(UDP, Lr_msg_type, dport=0x04d2)

##packet_list

#No possible packets which can be parsed to the final state