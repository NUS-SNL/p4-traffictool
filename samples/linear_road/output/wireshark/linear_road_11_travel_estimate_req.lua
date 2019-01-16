-- protocol naming
p4_travel_estimate_req = Proto('p4_travel_estimate_req','P4_TRAVEL_ESTIMATE_REQProtocol')

-- protocol fields
local p4_travel_estimate_req_time = ProtoField.string('p4_travel_estimate_req.time','time')
local p4_travel_estimate_req_qid = ProtoField.string('p4_travel_estimate_req.qid','qid')
local p4_travel_estimate_req_xway = ProtoField.string('p4_travel_estimate_req.xway','xway')
local p4_travel_estimate_req_seg_init = ProtoField.string('p4_travel_estimate_req.seg_init','seg_init')
local p4_travel_estimate_req_seg_end = ProtoField.string('p4_travel_estimate_req.seg_end','seg_end')
local p4_travel_estimate_req_dow = ProtoField.string('p4_travel_estimate_req.dow','dow')
local p4_travel_estimate_req_tod = ProtoField.string('p4_travel_estimate_req.tod','tod')
p4_travel_estimate_req.fields = {p4_travel_estimate_req_time, p4_travel_estimate_req_qid, p4_travel_estimate_req_xway, p4_travel_estimate_req_seg_init, p4_travel_estimate_req_seg_end, p4_travel_estimate_req_dow, p4_travel_estimate_req_tod}


-- protocol dissector function
function p4_travel_estimate_req.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TRAVEL_ESTIMATE_REQ'
	local subtree = tree:add(p4_travel_estimate_req,buffer(),'P4_TRAVEL_ESTIMATE_REQ Protocol Data')
		subtree:add(p4_travel_estimate_req_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_travel_estimate_req_qid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_travel_estimate_req_xway,tostring(buffer(6,1):bitfield(0,8)))
		subtree:add(p4_travel_estimate_req_seg_init,tostring(buffer(7,1):bitfield(0,8)))
		subtree:add(p4_travel_estimate_req_seg_end,tostring(buffer(8,1):bitfield(0,8)))
		subtree:add(p4_travel_estimate_req_dow,tostring(buffer(9,1):bitfield(0,8)))
		subtree:add(p4_travel_estimate_req_tod,tostring(buffer(10,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x04,p4_travel_estimate_req)
