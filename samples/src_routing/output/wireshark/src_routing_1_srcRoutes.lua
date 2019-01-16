-- protocol naming
p4_srcroutes = Proto('p4_srcroutes','P4_SRCROUTESProtocol')

-- protocol fields
local p4_srcroutes__pad0 = ProtoField.string('p4_srcroutes._pad0','_pad0')
local p4_srcroutes_bos = ProtoField.string('p4_srcroutes.bos','bos')
local p4_srcroutes__pad1 = ProtoField.string('p4_srcroutes._pad1','_pad1')
local p4_srcroutes_port = ProtoField.string('p4_srcroutes.port','port')
p4_srcroutes.fields = {p4_srcroutes__pad0, p4_srcroutes_bos, p4_srcroutes__pad1, p4_srcroutes_port}


-- protocol dissector function
function p4_srcroutes.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SRCROUTES'
	local subtree = tree:add(p4_srcroutes,buffer(),'P4_SRCROUTES Protocol Data')
		subtree:add(p4_srcroutes__pad0,tostring(buffer(0,1):bitfield(0,7)))
		subtree:add(p4_srcroutes_bos,tostring(buffer(0,1):bitfield(7,1)))
		subtree:add(p4_srcroutes__pad1,tostring(buffer(1,1):bitfield(0,1)))
		subtree:add(p4_srcroutes_port,tostring(buffer(1,2):bitfield(1,15)))
	local mydissectortable = DissectorTable.get('p4_srcRoutes.bos')
	mydissectortable:try(buffer(0,1):bitfield(7,1), buffer:range(3):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_srcRoutes.bos','P4_SRCROUTES.BOS',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x1234,p4_srcroutes)
my_table = DissectorTable.get('p4_srcRoutes.bos')
my_table:add(0x0,p4_srcroutes)
