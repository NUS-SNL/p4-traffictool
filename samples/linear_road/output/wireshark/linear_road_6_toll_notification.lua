-- protocol naming
p4_toll_notification = Proto('p4_toll_notification','P4_TOLL_NOTIFICATIONProtocol')

-- protocol fields
local p4_toll_notification_time = ProtoField.string('p4_toll_notification.time','time')
local p4_toll_notification_vid = ProtoField.string('p4_toll_notification.vid','vid')
local p4_toll_notification_emit = ProtoField.string('p4_toll_notification.emit','emit')
local p4_toll_notification_spd = ProtoField.string('p4_toll_notification.spd','spd')
local p4_toll_notification_toll = ProtoField.string('p4_toll_notification.toll','toll')
p4_toll_notification.fields = {p4_toll_notification_time, p4_toll_notification_vid, p4_toll_notification_emit, p4_toll_notification_spd, p4_toll_notification_toll}


-- protocol dissector function
function p4_toll_notification.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TOLL_NOTIFICATION'
	local subtree = tree:add(p4_toll_notification,buffer(),'P4_TOLL_NOTIFICATION Protocol Data')
		subtree:add(p4_toll_notification_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_toll_notification_vid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_toll_notification_emit,tostring(buffer(6,2):bitfield(0,16)))
		subtree:add(p4_toll_notification_spd,tostring(buffer(8,1):bitfield(0,8)))
		subtree:add(p4_toll_notification_toll,tostring(buffer(9,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x0a,p4_toll_notification)
