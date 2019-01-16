-- protocol naming
p4_accnt_bal = Proto('p4_accnt_bal','P4_ACCNT_BALProtocol')

-- protocol fields
local p4_accnt_bal_time = ProtoField.string('p4_accnt_bal.time','time')
local p4_accnt_bal_vid = ProtoField.string('p4_accnt_bal.vid','vid')
local p4_accnt_bal_emit = ProtoField.string('p4_accnt_bal.emit','emit')
local p4_accnt_bal_qid = ProtoField.string('p4_accnt_bal.qid','qid')
local p4_accnt_bal_bal = ProtoField.string('p4_accnt_bal.bal','bal')
p4_accnt_bal.fields = {p4_accnt_bal_time, p4_accnt_bal_vid, p4_accnt_bal_emit, p4_accnt_bal_qid, p4_accnt_bal_bal}


-- protocol dissector function
function p4_accnt_bal.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ACCNT_BAL'
	local subtree = tree:add(p4_accnt_bal,buffer(),'P4_ACCNT_BAL Protocol Data')
		subtree:add(p4_accnt_bal_time,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_accnt_bal_vid,tostring(buffer(2,4):bitfield(0,32)))
		subtree:add(p4_accnt_bal_emit,tostring(buffer(6,2):bitfield(0,16)))
		subtree:add(p4_accnt_bal_qid,tostring(buffer(8,4):bitfield(0,32)))
		subtree:add(p4_accnt_bal_bal,tostring(buffer(12,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x0c,p4_accnt_bal)
