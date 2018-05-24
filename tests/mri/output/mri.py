from scapy import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		BitField('dstAddr',0,48),
		BitField('srcAddr',0,48),
		BitField('etherType',0,16)
	]
class Ipv4(Packet):
	name = 'ipv4'
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
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Ipv4_option(Packet):
	name = 'ipv4_option'
	fields_desc = [
		BitField('copyFlag',0,1),
		BitField('optClass',0,2),
		BitField('option',0,5),
		BitField('optionLength',0,8)
	]
class Mri(Packet):
	name = 'mri'
	fields_desc = [
		BitField('count',0,16)
	]
class Swids_0(Packet):
	name = 'swids[0]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_1(Packet):
	name = 'swids[1]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_2(Packet):
	name = 'swids[2]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_3(Packet):
	name = 'swids[3]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_4(Packet):
	name = 'swids[4]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_5(Packet):
	name = 'swids[5]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_6(Packet):
	name = 'swids[6]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_7(Packet):
	name = 'swids[7]'
	fields_desc = [
		BitField('swid',0,32)
	]
class Swids_8(Packet):
	name = 'swids[8]'
	fields_desc = [
		BitField('swid',0,32)
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4, Ipv4_option, ihl = default)
bind_layers(Ipv4_option, Mri, option = 0x1f)

##packet_list
_possible_packets_ = [
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()/Swids_4()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()/Swids_4()/Swids_5()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Ipv4_option())
]
