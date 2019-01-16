-- protocol naming
p4_lr_msg_type = Proto('p4_lr_msg_type','P4_LR_MSG_TYPEProtocol')

-- protocol fields
local p4_lr_msg_type_msg_type = ProtoField.string('p4_lr_msg_type.msg_type','msg_type')
p4_lr_msg_type.fields = {p4_lr_msg_type_msg_type}


-- protocol dissector function
function p4_lr_msg_type.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_LR_MSG_TYPE'
	local subtree = tree:add(p4_lr_msg_type,buffer(),'P4_LR_MSG_TYPE Protocol Data')
		subtree:add(p4_lr_msg_type_msg_type,tostring(buffer(0,1):bitfield(0,8)))
	local mydissectortable = DissectorTable.get('p4_lr_msg_type.msg_type')
	mydissectortable:try(buffer(0,1):bitfield(0,8), buffer:range(1):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_lr_msg_type.msg_type','P4_LR_MSG_TYPE.MSG_TYPE',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x04d2,p4_lr_msg_type)
