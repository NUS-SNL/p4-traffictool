-- protocol naming
p4_proto = Proto('p4_mytunnel','P4_MYTUNNELProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_MYTUNNEL'
	local subtree = tree:add(p4_proto,buffer(),'P4_MYTUNNEL Protocol Data')
		subtree:add(buffer(0,2), 'proto_id (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,2), 'dst_id (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
	local mydissectortable = DissectorTable.get('p4_myTunnel.proto_id')
	mydissectortable:try(buffer(0,2):bitfield(0,16), buffer:range(4):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x1212,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_myTunnel.proto_id','P4_MYTUNNEL.PROTO_ID',ftypes.STRING)