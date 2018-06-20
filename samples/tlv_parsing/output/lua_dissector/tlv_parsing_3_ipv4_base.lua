-- protocol naming
p4_proto = Proto('p4_ipv4_base','P4_IPV4_BASEProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_BASE'
	local subtree = tree:add(p4_proto,buffer(),'P4_IPV4_BASE Protocol Data')
		subtree:add(buffer(0,1), 'version (4 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,4))))
		subtree:add(buffer(0,2), 'ihl (4 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(4,4))))
		subtree:add(buffer(1,1), 'diffserv (8 bits):' .. string.format('%X', tostring(buffer(1,1):bitfield(0,8))))
		subtree:add(buffer(2,2), 'totalLen (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
		subtree:add(buffer(4,2), 'identification (16 bits):' .. string.format('%X', tostring(buffer(4,2):bitfield(0,16))))
		subtree:add(buffer(6,1), 'flags (3 bits):' .. string.format('%X', tostring(buffer(6,1):bitfield(0,3))))
		subtree:add(buffer(6,3), 'fragOffset (13 bits):' .. string.format('%X', tostring(buffer(6,3):bitfield(3,13))))
		subtree:add(buffer(8,1), 'ttl (8 bits):' .. string.format('%X', tostring(buffer(8,1):bitfield(0,8))))
		subtree:add(buffer(9,1), 'protocol (8 bits):' .. string.format('%X', tostring(buffer(9,1):bitfield(0,8))))
		subtree:add(buffer(10,2), 'hdrChecksum (16 bits):' .. string.format('%X', tostring(buffer(10,2):bitfield(0,16))))
		subtree:add(buffer(12,4), 'srcAddr (32 bits):' .. string.format('%X', tostring(buffer(12,4):bitfield(0,32))))
		subtree:add(buffer(16,4), 'dstAddr (32 bits):' .. string.format('%X', tostring(buffer(16,4):bitfield(0,32))))
	 mydissectortable:try(buffer(0,1):bitfield(4,4), buffer:range(20):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x0800,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_ipv4_base.ihl','P4_IPV4_BASE.IHL',ftypes.STRING)