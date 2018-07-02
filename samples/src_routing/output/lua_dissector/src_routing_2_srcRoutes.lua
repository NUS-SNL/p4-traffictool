-- protocol naming
p4_srcroutes = Proto('p4_srcroutes','P4_SRCROUTESProtocol')
-- protocol fields
local p4_srcroutes_bos = ProtoField.string('p4_srcroutes.bos','bos')
local p4_srcroutes_port = ProtoField.string('p4_srcroutes.port','port')
p4_srcroutes.fields = {p4_srcroutes_bos, p4_srcroutes_port}


-- protocol dissector function
function p4_srcroutes.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SRCROUTES'
	local subtree = tree:add(p4_srcroutes,buffer(),'P4_SRCROUTES Protocol Data')
		subtree:add(p4_srcroutes_bos,tostring(buffer(0,1):bitfield(0,1)))
		subtree:add(p4_srcroutes_port,tostring(buffer(0,3):bitfield(1,15)))
	local mydissectortable = DissectorTable.get('p4_srcRoutes.bos')
	mydissectortable:try(buffer(0,0):bitfield(0,1), buffer:range(2):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x1234,p4_srcroutes)
my_table = DissectorTable.get('p4_srcRoutes.bos')
my_table:add(default,p4_srcroutes)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_srcRoutes.bos','P4_SRCROUTES.BOS',ftypes.STRING)