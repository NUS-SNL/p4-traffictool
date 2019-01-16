from scapy.all import *

##class definitions
class Hula(Packet):
	name = 'hula'
	fields_desc = [
		XBitField('_pad0', 0, 7),
		XBitField('dir', 0, 1),
		XBitField('_pad1', 0, 1),
		XBitField('qdepth', 0, 15),
		XIntField('digest', 0),
	]
class SrcRoutes(Packet):
	name = 'srcRoutes'
	fields_desc = [
		XBitField('_pad0', 0, 7),
		XBitField('bos', 0, 1),
		XBitField('_pad1', 0, 1),
		XBitField('port', 0, 15),
	]

##bindings
bind_layers(Ether, Hula, type = 0x2345)
bind_layers(Ether, IP, type = 0x0800)
bind_layers(Hula,SrcRoutes)
bind_layers(SrcRoutes, IP, bos = 0x01)
bind_layers(SrcRoutes,SrcRoutes)
bind_layers(IP, UDP, proto = 0x11)

##packet_list
possible_packets_ = [
	(Ether()),
	(Ether()/IP()),
	(Ether()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP()/UDP()),
	(Ether()/Hula()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/SrcRoutes()/IP())
]
