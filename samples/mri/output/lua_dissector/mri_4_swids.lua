-- protocol naming
p4_proto = Proto('p4_swids','P4_SWIDSProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SWIDS'
	local subtree = tree:add(p4_proto,buffer(),'P4_SWIDS Protocol Data')
		subtree:add(buffer(0,4), 'swid (32 bits):' .. string.format('%X', tostring(buffer(0,4):bitfield(0,32))))
	local mydissectortable = DissectorTable.get('p4_swids.remaining')
	 Could not detect suitable parameters

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_mri.remaining')
my_table:add(default,p4_proto)
my_table = DissectorTable.get('p4_swids.remaining')
my_table:add(default,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_swids.remaining','P4_SWIDS.REMAINING',ftypes.STRING)