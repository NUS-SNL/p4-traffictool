-- protocol naming
p4_proto = Proto('p4_srcroutes','P4_SRCROUTESProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SRCROUTES'
	local subtree = tree:add(p4_proto,buffer(),'P4_SRCROUTES Protocol Data')
		subtree:add(buffer(0,1), 'bos (1 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,1))))
		subtree:add(buffer(0,3), 'port (15 bits):' .. string.format('%X', tostring(buffer(0,3):bitfield(1,15))))
	local mydissectortable = DissectorTable.get('p4_srcRoutes.bos')
	mydissectortable:try(buffer(0,0):bitfield(0,1), buffer:range(2):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x1234,p4_proto)
my_table = DissectorTable.get('p4_srcRoutes.bos')
my_table:add(default,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_srcRoutes.bos','P4_SRCROUTES.BOS',ftypes.STRING)