-- protocol naming
p4_nc_load = Proto('p4_nc_load','P4_NC_LOADProtocol')

-- protocol fields
local p4_nc_load_load_1 = ProtoField.string('p4_nc_load.load_1','load_1')
local p4_nc_load_load_2 = ProtoField.string('p4_nc_load.load_2','load_2')
local p4_nc_load_load_3 = ProtoField.string('p4_nc_load.load_3','load_3')
local p4_nc_load_load_4 = ProtoField.string('p4_nc_load.load_4','load_4')
p4_nc_load.fields = {p4_nc_load_load_1, p4_nc_load_load_2, p4_nc_load_load_3, p4_nc_load_load_4}


-- protocol dissector function
function p4_nc_load.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_NC_LOAD'
	local subtree = tree:add(p4_nc_load,buffer(),'P4_NC_LOAD Protocol Data')
		subtree:add(p4_nc_load_load_1,tostring(buffer(0,4):bitfield(0,32)))
		subtree:add(p4_nc_load_load_2,tostring(buffer(4,4):bitfield(0,32)))
		subtree:add(p4_nc_load_load_3,tostring(buffer(8,4):bitfield(0,32)))
		subtree:add(p4_nc_load_load_4,tostring(buffer(12,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_nc_hdr.op')
my_table:add(0x02,p4_nc_load)
