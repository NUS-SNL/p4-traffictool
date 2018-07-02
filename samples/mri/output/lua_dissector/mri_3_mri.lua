-- protocol naming
p4_mri = Proto('p4_mri','P4_MRIProtocol')
-- protocol fields
local p4_mri_count = ProtoField.string('p4_mri.count','count')
p4_mri.fields = {p4_mri_count}


-- protocol dissector function
function p4_mri.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_MRI'
	local subtree = tree:add(p4_mri,buffer(),'P4_MRI Protocol Data')
		subtree:add(p4_mri_count,tostring(buffer(0,2):bitfield(0,16)))
	local mydissectortable = DissectorTable.get('p4_mri.remaining')
	 Could not detect suitable parameters

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4_option.option')
my_table:add(0x1f,p4_mri)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_mri.remaining','P4_MRI.REMAINING',ftypes.STRING)