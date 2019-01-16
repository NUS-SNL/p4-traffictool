-- protocol naming
p4_accident_alert = Proto('p4_accident_alert','P4_ACCIDENT_ALERTProtocol')

-- protocol fields
local p4_accident_alert_time = ProtoField.string('p4_accident_alert.time','time')
local p4_accident_alert_vid = ProtoField.string('p4_accident_alert.vid','vid')
local p4_accident_alert_emit = ProtoField.string('p4_accident_alert.emit','emit')
local p4_accident_alert_seg = ProtoField.string('p4_accident_alert.seg','seg')
p4_accident_alert.fields = {p4_accident_alert_time, p4_accident_alert_vid, p4_accident_alert_emit, p4_accident_alert_seg}


-- protocol dissector function
function p4_accident_alert.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ACCIDENT_ALERT'
	local subtree = tree:add(p4_accident_alert,buffer(),'P4_ACCIDENT_ALERT Protocol Data')
		subtree:add(p4_accident_alert_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_accident_alert_vid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_accident_alert_emit,tostring(buffer(6,2):bitfield(0,16)))
		subtree:add(p4_accident_alert_seg,tostring(buffer(8,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x0b,p4_accident_alert)
