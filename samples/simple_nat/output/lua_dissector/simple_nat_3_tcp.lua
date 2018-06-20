-- protocol naming
p4_proto = Proto('p4_tcp','P4_TCPProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TCP'
	local subtree = tree:add(p4_proto,buffer(),'P4_TCP Protocol Data')
		subtree:add(buffer(0,2), 'srcPort (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,2), 'dstPort (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
		subtree:add(buffer(4,4), 'seqNo (32 bits):' .. string.format('%X', tostring(buffer(4,4):bitfield(0,32))))
		subtree:add(buffer(8,4), 'ackNo (32 bits):' .. string.format('%X', tostring(buffer(8,4):bitfield(0,32))))
		subtree:add(buffer(12,1), 'dataOffset (4 bits):' .. string.format('%X', tostring(buffer(12,1):bitfield(0,4))))
		subtree:add(buffer(12,2), 'res (4 bits):' .. string.format('%X', tostring(buffer(12,2):bitfield(4,4))))
		subtree:add(buffer(13,1), 'flags (8 bits):' .. string.format('%X', tostring(buffer(13,1):bitfield(0,8))))
		subtree:add(buffer(14,2), 'window (16 bits):' .. string.format('%X', tostring(buffer(14,2):bitfield(0,16))))
		subtree:add(buffer(16,2), 'checksum (16 bits):' .. string.format('%X', tostring(buffer(16,2):bitfield(0,16))))
		subtree:add(buffer(18,2), 'urgentPtr (16 bits):' .. string.format('%X', tostring(buffer(18,2):bitfield(0,16))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x06,p4_proto)

-- creation of table for next layer(if required)
