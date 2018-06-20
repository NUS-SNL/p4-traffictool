from scapy.all import *

##class definitions
class Tmp_hdr(Packet):
	name = 'tmp_hdr'
	fields_desc = [
		XBitField('value',0,8),
		XBitField('len',0,8)
	]
class Tmp_hdr_0(Packet):
	name = 'tmp_hdr_0'
	fields_desc = [
		XBitField('data',0,<insert length for variable field here or handle it in post_build>)
	]
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr',0,48),
		XBitField('srcAddr',0,48),
		XBitField('etherType',0,16)
	]
class Ipv4_base(Packet):
	name = 'ipv4_base'
	fields_desc = [
		XBitField('version',0,4),
		XBitField('ihl',0,4),
		XBitField('diffserv',0,8),
		XBitField('totalLen',0,16),
		XBitField('identification',0,16),
		XBitField('flags',0,3),
		XBitField('fragOffset',0,13),
		XBitField('ttl',0,8),
		XBitField('protocol',0,8),
		XBitField('hdrChecksum',0,16),
		XBitField('srcAddr',0,32),
		XBitField('dstAddr',0,32)
	]
	#update hdrChecksum over [[u'ipv4_base', u'version'], [u'ipv4_base', u'ihl'], [u'ipv4_base', u'diffserv'], [u'ipv4_base', u'totalLen'], [u'ipv4_base', u'identification'], [u'ipv4_base', u'flags'], [u'ipv4_base', u'fragOffset'], [u'ipv4_base', u'ttl'], [u'ipv4_base', u'protocol'], [u'ipv4_base', u'srcAddr'], [u'ipv4_base', u'dstAddr'], u'ipv4_option_security', u'ipv4_option_NOP[0]', u'ipv4_option_timestamp'] using csum16 in post_build method

class Ipv4_option_security(Packet):
	name = 'ipv4_option_security'
	fields_desc = [
		XBitField('value',0,8),
		XBitField('len',0,8),
		XBitField('security',0,72)
	]
class Ipv4_option_timestamp(Packet):
	name = 'ipv4_option_timestamp'
	fields_desc = [
		XBitField('value',0,8),
		XBitField('len',0,8),
		XBitField('data',0,<insert length for variable field here or handle it in post_build>)
	]
class Ipv4_option_EOL_0(Packet):
	name = 'ipv4_option_EOL[0]'
	fields_desc = [
		XBitField('value',0,8)
	]
class Ipv4_option_EOL_1(Packet):
	name = 'ipv4_option_EOL[1]'
	fields_desc = [
		XBitField('value',0,8)
	]
class Ipv4_option_EOL_2(Packet):
	name = 'ipv4_option_EOL[2]'
	fields_desc = [
		XBitField('value',0,8)
	]
class Ipv4_option_NOP_0(Packet):
	name = 'ipv4_option_NOP[0]'
	fields_desc = [
		XBitField('value',0,8)
	]
class Ipv4_option_NOP_1(Packet):
	name = 'ipv4_option_NOP[1]'
	fields_desc = [
		XBitField('value',0,8)
	]
class Ipv4_option_NOP_2(Packet):
	name = 'ipv4_option_NOP[2]'
	fields_desc = [
		XBitField('value',0,8)
	]

##bindings
bind_layers(Ethernet, Ipv4_base, etherType = 0x0800)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_EOL_2()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Tmp_hdr()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_EOL_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Tmp_hdr()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Tmp_hdr()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_security()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Tmp_hdr()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Tmp_hdr()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_security()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_NOP_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_NOP_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_NOP_2()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Tmp_hdr()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_EOL_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Tmp_hdr()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Tmp_hdr()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_security()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_security()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Tmp_hdr()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Tmp_hdr()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Tmp_hdr()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_security()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_security()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Tmp_hdr()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_security()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Tmp_hdr()/Ipv4_option_NOP_0()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_security()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Tmp_hdr()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_EOL_1()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_NOP_0()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_security()/Ipv4_option_security()/Tmp_hdr()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Tmp_hdr()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0()/Ipv4_option_NOP_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_NOP_0()/Ipv4_option_NOP_1()/Ipv4_option_security()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Tmp_hdr()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Ipv4_option_EOL_0()/Ipv4_option_security()/Ipv4_option_EOL_1()),
	(Ethernet()/Ipv4_base()/Tmp_hdr()/Ipv4_option_NOP_0()/Ipv4_option_EOL_0())
]
