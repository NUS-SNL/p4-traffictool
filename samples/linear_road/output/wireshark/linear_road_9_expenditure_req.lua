-- protocol naming
p4_expenditure_req = Proto('p4_expenditure_req','P4_EXPENDITURE_REQProtocol')

-- protocol fields
local p4_expenditure_req_time = ProtoField.string('p4_expenditure_req.time','time')
local p4_expenditure_req_vid = ProtoField.string('p4_expenditure_req.vid','vid')
local p4_expenditure_req_qid = ProtoField.string('p4_expenditure_req.qid','qid')
local p4_expenditure_req_xway = ProtoField.string('p4_expenditure_req.xway','xway')
local p4_expenditure_req_day = ProtoField.string('p4_expenditure_req.day','day')
p4_expenditure_req.fields = {p4_expenditure_req_time, p4_expenditure_req_vid, p4_expenditure_req_qid, p4_expenditure_req_xway, p4_expenditure_req_day}


-- protocol dissector function
function p4_expenditure_req.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_EXPENDITURE_REQ'
	local subtree = tree:add(p4_expenditure_req,buffer(),'P4_EXPENDITURE_REQ Protocol Data')
		subtree:add(p4_expenditure_req_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_expenditure_req_vid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_expenditure_req_qid,tostring(buffer(6,4):bitfield(0,32)))
		subtree:add(p4_expenditure_req_xway,tostring(buffer(10,1):bitfield(0,8)))
		subtree:add(p4_expenditure_req_day,tostring(buffer(11,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x03,p4_expenditure_req)
