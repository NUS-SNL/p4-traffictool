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
class Swids(Packet):
	name = 'swids'
	fields_desc = [
		XIntField('swid', 0),
	]
	#update hdrChecksum over [[u'ipv4', u'version'], [u'ipv4', u'ihl'], [u'ipv4', u'diffserv'], [u'ipv4', u'totalLen'], [u'ipv4', u'identification'], [u'ipv4', u'flags'], [u'ipv4', u'fragOffset'], [u'ipv4', u'ttl'], [u'ipv4', u'protocol'], [u'ipv4', u'srcAddr'], [u'ipv4', u'dstAddr']] using csum16 in post_build method

class Mri(Packet):
	name = 'mri'
	fields_desc = [
		XShortField('count', 0),
	]

##bindings
bind_layers(Ether, IP, type = 0x0800)
bind_layers(IP,Ipv4_option)
bind_layers(Ipv4_option, Mri, option = 0x1f)
bind_layers(Mri,Swids)
bind_layers(Swids,Swids)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/Ipv4_option()),
	(Ether()/IP()/Ipv4_option()/Mri()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()/Swids()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()/Swids()),
	(Ether()/IP()/Ipv4_option()/Mri()/Swids()/Swids()/Swids()/Swids()/Swids()/Swids())
]
