from scapy.all import *

##class definitions
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
class Travel_estimate(Packet):
	name = 'travel_estimate'
	fields_desc = [
		XIntField('qid', 0),
		XShortField('travel_time', 0),
		XShortField('toll', 0),
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
class Expenditure_req(Packet):
	name = 'expenditure_req'
	fields_desc = [
		XShortField('time', 0),
		XIntField('vid', 0),
		XIntField('qid', 0),
		XByteField('xway', 0),
		XByteField('day', 0),
	]
class Accident_alert(Packet):
	name = 'accident_alert'
	fields_desc = [
		XShortField('time', 0),
		XIntField('vid', 0),
		XShortField('emit', 0),
		XByteField('seg', 0),
	]
class Toll_notification(Packet):
	name = 'toll_notification'
	fields_desc = [
		XShortField('time', 0),
		XIntField('vid', 0),
		XShortField('emit', 0),
		XByteField('spd', 0),
		XShortField('toll', 0),
	]
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Lr_msg_type(Packet):
	name = 'lr_msg_type'
	fields_desc = [
		XByteField('msg_type', 0),
	]
class Expenditure_report(Packet):
	name = 'expenditure_report'
	fields_desc = [
		XShortField('time', 0),
		XShortField('emit', 0),
		XIntField('qid', 0),
		XShortField('bal', 0),
	]
class Accnt_bal_req(Packet):
	name = 'accnt_bal_req'
	fields_desc = [
		XShortField('time', 0),
		XIntField('vid', 0),
		XIntField('qid', 0),
	]

##bindings
bind_layers(Ether, IP, type = 0x0800)
bind_layers(IP, UDP, proto = 0x11)
bind_layers(Lr_msg_type, Pos_report, msg_type = 0x00)
bind_layers(Lr_msg_type, Accnt_bal_req, msg_type = 0x02)
bind_layers(Lr_msg_type, Toll_notification, msg_type = 0x0a)
bind_layers(Lr_msg_type, Accident_alert, msg_type = 0x0b)
bind_layers(Lr_msg_type, Accnt_bal, msg_type = 0x0c)
bind_layers(Lr_msg_type, Expenditure_req, msg_type = 0x03)
bind_layers(Lr_msg_type, Expenditure_report, msg_type = 0x0d)
bind_layers(Lr_msg_type, Travel_estimate_req, msg_type = 0x04)
bind_layers(Lr_msg_type, Travel_estimate, msg_type = 0x0e)
bind_layers(UDP, Lr_msg_type, dport = 0x04d2)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/UDP()),
	(Ether()/IP()/UDP()/Lr_msg_type()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Accnt_bal()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Accnt_bal_req()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Expenditure_req()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Travel_estimate_req()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Travel_estimate()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Toll_notification()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Pos_report()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Expenditure_report()),
	(Ether()/IP()/UDP()/Lr_msg_type()/Accident_alert())
]
