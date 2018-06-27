-- protocol naming
p4_proto = Proto('p4_mri','P4_MRIProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_MRI'
	local subtree = tree:add(p4_proto,buffer(),'P4_MRI Protocol Data')
		subtree:add(buffer(0,2), 'count (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
	local mydissectortable = DissectorTable.get('p4_mri.remaining')
	 Could not detect suitable parameters

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4_option.option')
my_table:add(0x1f,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_mri.remaining','P4_MRI.REMAINING',ftypes.STRING)