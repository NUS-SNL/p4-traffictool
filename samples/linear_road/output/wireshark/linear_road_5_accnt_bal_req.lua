-- protocol naming
p4_accnt_bal_req = Proto('p4_accnt_bal_req','P4_ACCNT_BAL_REQProtocol')

-- protocol fields
local p4_accnt_bal_req_time = ProtoField.string('p4_accnt_bal_req.time','time')
local p4_accnt_bal_req_vid = ProtoField.string('p4_accnt_bal_req.vid','vid')
local p4_accnt_bal_req_qid = ProtoField.string('p4_accnt_bal_req.qid','qid')
p4_accnt_bal_req.fields = {p4_accnt_bal_req_time, p4_accnt_bal_req_vid, p4_accnt_bal_req_qid}


-- protocol dissector function
function p4_accnt_bal_req.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ACCNT_BAL_REQ'
	local subtree = tree:add(p4_accnt_bal_req,buffer(),'P4_ACCNT_BAL_REQ Protocol Data')
		subtree:add(p4_accnt_bal_req_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_accnt_bal_req_vid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_accnt_bal_req_qid,tostring(buffer(6,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x02,p4_accnt_bal_req)
