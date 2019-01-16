-- protocol naming
p4_travel_estimate = Proto('p4_travel_estimate','P4_TRAVEL_ESTIMATEProtocol')

-- protocol fields
local p4_travel_estimate_qid = ProtoField.string('p4_travel_estimate.qid','qid')
local p4_travel_estimate_travel_time = ProtoField.string('p4_travel_estimate.travel_time','travel_time')
local p4_travel_estimate_toll = ProtoField.string('p4_travel_estimate.toll','toll')
p4_travel_estimate.fields = {p4_travel_estimate_qid, p4_travel_estimate_travel_time, p4_travel_estimate_toll}


-- protocol dissector function
function p4_travel_estimate.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TRAVEL_ESTIMATE'
	local subtree = tree:add(p4_travel_estimate,buffer(),'P4_TRAVEL_ESTIMATE Protocol Data')
		subtree:add(p4_travel_estimate_qid,tostring(buffer(0,4):bitfield(0,32)))
		subtree:add(p4_travel_estimate_travel_time,tostring(buffer(4,2):bitfield(0,16)))
		subtree:add(p4_travel_estimate_toll,tostring(buffer(6,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x0e,p4_travel_estimate)
