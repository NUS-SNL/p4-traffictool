-- protocol naming
p4_mytunnel = Proto('p4_mytunnel','P4_MYTUNNELProtocol')

-- protocol fields
local p4_mytunnel_proto_id = ProtoField.string('p4_mytunnel.proto_id','proto_id')
local p4_mytunnel_dst_id = ProtoField.string('p4_mytunnel.dst_id','dst_id')
p4_mytunnel.fields = {p4_mytunnel_proto_id, p4_mytunnel_dst_id}


-- protocol dissector function
function p4_mytunnel.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_MYTUNNEL'
	local subtree = tree:add(p4_mytunnel,buffer(),'P4_MYTUNNEL Protocol Data')
		subtree:add(p4_mytunnel_proto_id,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_mytunnel_dst_id,tostring(buffer(2,2):bitfield(0,16)))
	local mydissectortable = DissectorTable.get('p4_myTunnel.proto_id')
	mydissectortable:try(buffer(0,2):bitfield(0,16), buffer:range(4):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_myTunnel.proto_id','P4_MYTUNNEL.PROTO_ID',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x1212,p4_mytunnel)
