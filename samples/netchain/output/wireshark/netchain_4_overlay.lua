-- protocol naming
p4_overlay = Proto('p4_overlay','P4_OVERLAYProtocol')

-- protocol fields
local p4_overlay_swip = ProtoField.string('p4_overlay.swip','swip')
p4_overlay.fields = {p4_overlay_swip}


-- protocol dissector function
function p4_overlay.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_OVERLAY'
	local subtree = tree:add(p4_overlay,buffer(),'P4_OVERLAY Protocol Data')
		subtree:add(p4_overlay_swip,tostring(buffer(0,4):bitfield(0,32)))
	local mydissectortable = DissectorTable.get('p4_overlay.swip')
	mydissectortable:try(buffer(0,4):bitfield(0,32), buffer:range(4):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_overlay.swip','P4_OVERLAY.SWIP',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('p4_overlay.swip')
my_table:add(0x0,p4_overlay)
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x22b8,p4_overlay)
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x22b9,p4_overlay)
