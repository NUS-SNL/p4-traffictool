from scapy.all import *

##class definitions
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField(dstAddr, 0, 48),
		XBitField(srcAddr, 0, 48),
		ShortField(etherType, 0),
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		XBitField(version, 0, 4),
		XBitField(ihl, 0, 4),
		ByteField(diffserv, 0),
		ShortField(totalLen, 0),
		ShortField(identification, 0),
		XBitField(flags, 0, 3),
		XBitField(fragOffset, 0, 13),
		ByteField(ttl, 0),
		ByteField(protocol, 0),
		ShortField(hdrChecksum, 0),
		IntField(srcAddr, 0),
		IntField(dstAddr, 0),
	]
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Ipv4_option(Packet):
	name = 'ipv4_option'
	fields_desc = [
		XBitField(copyFlag, 0, 1),
		XBitField(optClass, 0, 2),
		XBitField(option, 0, 5),
		ByteField(optionLength, 0),
	]
class Mri(Packet):
	name = 'mri'
	fields_desc = [
		ShortField(count, 0),
	]
class Swids_0(Packet):
	name = 'swids[0]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_1(Packet):
	name = 'swids[1]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_2(Packet):
	name = 'swids[2]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_3(Packet):
	name = 'swids[3]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_4(Packet):
	name = 'swids[4]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_5(Packet):
	name = 'swids[5]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_6(Packet):
	name = 'swids[6]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_7(Packet):
	name = 'swids[7]'
	fields_desc = [
		IntField(swid, 0),
	]
class Swids_8(Packet):
	name = 'swids[8]'
	fields_desc = [
		IntField(swid, 0),
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4,Ipv4_option)
bind_layers(Ipv4_option, Mri, option = 0x1f)

##packet_list
possible_packets = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Ipv4_option()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()/Swids_4()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids_0()/Swids_1()/Swids_2()/Swids_3()/Swids_4()/Swids_5())
]
