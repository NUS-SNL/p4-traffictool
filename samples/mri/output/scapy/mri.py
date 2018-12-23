from scapy.all import *

##class definitions
class Swids(Packet):
	name = 'swids'
	fields_desc = [
		XIntField('swid', 0),
	]
class Ipv4_option(Packet):
	name = 'ipv4_option'
	fields_desc = [
		XBitField('copyFlag', 0, 1),
		XBitField('optClass', 0, 2),
		XBitField('option', 0, 5),
		XByteField('optionLength', 0),
	]
class Mri(Packet):
	name = 'mri'
	fields_desc = [
		XShortField('count', 0),
	]
class Ethernet(Packet):
	name = 'ethernet'
	fields_desc = [
		XBitField('dstAddr', 0, 48),
		XBitField('srcAddr', 0, 48),
		XShortField('etherType', 0),
	]
class Ipv4(Packet):
	name = 'ipv4'
	fields_desc = [
		XBitField('version', 0, 4),
		XBitField('ihl', 0, 4),
		XByteField('diffserv', 0),
		XShortField('totalLen', 0),
		XShortField('identification', 0),
		XBitField('flags', 0, 3),
		XBitField('fragOffset', 0, 13),
		XByteField('ttl', 0),
		XByteField('protocol', 0),
		XShortField('hdrChecksum', 0),
		XIntField('srcAddr', 0),
		XIntField('dstAddr', 0),
	]

##bindings
bind_layers(Ethernet, Ipv4, etherType = 0x0800)
bind_layers(Ipv4,Ipv4_option)
bind_layers(Ipv4_option, Mri, option = 0x1f)
bind_layers(Mri,Swids)
bind_layers(Swids,Swids)

##packet_list
possible_packets_ = [
	(Ethernet()),
	(Ethernet()/Ipv4()),
	(Ethernet()/Ipv4()/Ipv4_option()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()/Swids()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()/Swids()),
	(Ethernet()/Ipv4()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()/Swids()/Swids())
]
