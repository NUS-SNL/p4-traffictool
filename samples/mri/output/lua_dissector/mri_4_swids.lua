-- protocol naming
p4_swids = Proto('p4_swids','P4_SWIDSProtocol')
-- protocol fields
local p4_swids_swid = ProtoField.string('p4_swids.swid','swid')
p4_swids.fields = {p4_swids_swid}


-- protocol dissector function
function p4_swids.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SWIDS'
	local subtree = tree:add(p4_swids,buffer(),'P4_SWIDS Protocol Data')
		subtree:add(p4_swids_swid,tostring(buffer(0,4):bitfield(0,32)))
	local mydissectortable = DissectorTable.get('p4_swids.remaining')
	 Could not detect suitable parameters

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_mri.remaining')
my_table:add(default,p4_swids)
my_table = DissectorTable.get('p4_swids.remaining')
my_table:add(default,p4_swids)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_swids.remaining','P4_SWIDS.REMAINING',ftypes.STRING)