from scapy.all import *

##class definitions
class Tmp_hdr(Packet):
	name = 'tmp_hdr'
	fields_desc = [
		ByteField(value, 0),
		ByteField(len, 0),
	]
class Tmp_hdr_0(Packet):
	name = 'tmp_hdr_0'
	fields_desc = [
