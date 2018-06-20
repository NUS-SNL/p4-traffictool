-- protocol naming
p4_proto = Proto('p4_icmp','P4_ICMPProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ICMP'
	local subtree = tree:add(p4_proto,buffer(),'P4_ICMP Protocol Data')
		subtree:add(buffer(0,1), 'type (8 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,8))))
		subtree:add(buffer(1,1), 'code (8 bits):' .. string.format('%X', tostring(buffer(1,1):bitfield(0,8))))
		subtree:add(buffer(2,2), 'checksum (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x01,p4_proto)

-- creation of table for next layer(if required)
