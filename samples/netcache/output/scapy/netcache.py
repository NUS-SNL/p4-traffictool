from scapy.all import *

##class definitions
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
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

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
class Nc_load(Packet):
	name = 'nc_load'
	fields_desc = [
		XIntField('load_1', 0),
		XIntField('load_2', 0),
		XIntField('load_3', 0),
		XIntField('load_4', 0),
	]
class Nc_value_8(Packet):
	name = 'nc_value_8'
	fields_desc = [
		XIntField('value_8_1', 0),
		XIntField('value_8_2', 0),
		XIntField('value_8_3', 0),
		XIntField('value_8_4', 0),
	]
class Nc_value_3(Packet):
	name = 'nc_value_3'
	fields_desc = [
		XIntField('value_3_1', 0),
		XIntField('value_3_2', 0),
		XIntField('value_3_3', 0),
		XIntField('value_3_4', 0),
	]
class Nc_hdr(Packet):
	name = 'nc_hdr'
	fields_desc = [
		XByteField('op', 0),
		XLongField('key', 0),
	]

##bindings
bind_layers(Ether, IP, type = 0x0800)
bind_layers(IP, TCP, proto = 0x06)
bind_layers(IP, UDP, proto = 0x11)
bind_layers(Nc_hdr, Nc_load, op = 0x02)
bind_layers(Nc_value_1,Nc_value_2)
bind_layers(Nc_value_2,Nc_value_3)
bind_layers(Nc_value_3,Nc_value_4)
bind_layers(Nc_value_4,Nc_value_5)
bind_layers(Nc_value_5,Nc_value_6)
bind_layers(Nc_value_6,Nc_value_7)
bind_layers(Nc_value_7,Nc_value_8)
bind_layers(UDP, Nc_hdr, dport = 0x22b8)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/UDP()),
	(Ether()/IP()/TCP()),
	(Ether()/IP()/UDP()/Nc_hdr()),
	(Ether()/IP()/UDP()/Nc_hdr()/Nc_load())
]
