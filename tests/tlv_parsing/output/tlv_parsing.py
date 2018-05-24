from scapy import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		BitField('dstAddr',0,48),
		BitField('srcAddr',0,48),
		BitField('etherType',0,16)
	]
class Ipv4_base(Packet):
	name = 'ipv4_base'
	fields_desc = [
		BitField('version',0,4),
		BitField('ihl',0,4),
		BitField('diffserv',0,8),
		BitField('totalLen',0,16),
		BitField('identification',0,16),
		BitField('flags',0,3),
		BitField('fragOffset',0,13),
		BitField('ttl',0,8),
		BitField('protocol',0,8),
		BitField('hdrChecksum',0,16),
		BitField('srcAddr',0,32),
		BitField('dstAddr',0,32)
	]
	#update hdrChecksum over [[u'ipv4_base', u'version'], [u'ipv4_base', u'ihl'], [u'ipv4_base', u'diffserv'], [u'ipv4_base', u'totalLen'], [u'ipv4_base', u'identification'], [u'ipv4_base', u'flags'], [u'ipv4_base', u'fragOffset'], [u'ipv4_base', u'ttl'], [u'ipv4_base', u'protocol'], [u'ipv4_base', u'srcAddr'], [u'ipv4_base', u'dstAddr'], [u'ipv4_option_security', u'value'], [u'ipv4_option_security', u'len'], [u'ipv4_option_security', u'security'], [u'ipv4_option_NOP[0]', u'value'], [u'ipv4_option_timestamp', u'value'], [u'ipv4_option_timestamp', u'len'], [u'ipv4_option_timestamp', u'data']] using csum16 in post_build method

class Ipv4_option_EOL_0(Packet):
	name = 'ipv4_option_EOL[0]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_EOL_1(Packet):
	name = 'ipv4_option_EOL[1]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_EOL_2(Packet):
	name = 'ipv4_option_EOL[2]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_NOP_0(Packet):
	name = 'ipv4_option_NOP[0]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_NOP_1(Packet):
	name = 'ipv4_option_NOP[1]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_NOP_2(Packet):
	name = 'ipv4_option_NOP[2]'
	fields_desc = [
		BitField('value',0,8)
	]
class Ipv4_option_security(Packet):
	name = 'ipv4_option_security'
	fields_desc = [
		BitField('value',0,8),
		BitField('len',0,8),
		BitField('security',0,72)
	]
class Ipv4_option_timestamp(Packet):
	name = 'ipv4_option_timestamp'
	fields_desc = [
		BitField('value',0,8),
		BitField('len',0,8),
		BitField('data',0,)
	]

##bindings
bind_layers(Ethernet, Ipv4_base, etherType = 0x0800)

##packet_list
_possible_packets_ = [
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_timestamp()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_NOP_2()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_timestamp()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_timestamp()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_EOL_2()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_timestamp())
]
