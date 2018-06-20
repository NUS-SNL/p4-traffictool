-- protocol naming
p4_proto = Proto('p4_udp','P4_UDPProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_UDP'
	local subtree = tree:add(p4_proto,buffer(),'P4_UDP Protocol Data')
		subtree:add(buffer(0,2), 'srcPort (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,2), 'dstPort (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
		subtree:add(buffer(4,2), 'hdr_length (16 bits):' .. string.format('%X', tostring(buffer(4,2):bitfield(0,16))))
		subtree:add(buffer(6,2), 'checksum (16 bits):' .. string.format('%X', tostring(buffer(6,2):bitfield(0,16))))
	 mydissectortable:try(buffer(2,2):bitfield(0,16), buffer:range(8):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x11,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_udp.dstPort','P4_UDP.DSTPORT',ftypes.STRING)