-- protocol naming
p4_q_meta = Proto('p4_q_meta','P4_Q_METAProtocol')

-- protocol fields
local p4_q_meta_flow_id = ProtoField.string('p4_q_meta.flow_id','flow_id')
local p4_q_meta__pad0 = ProtoField.string('p4_q_meta._pad0','_pad0')
local p4_q_meta_ingress_global_tstamp = ProtoField.string('p4_q_meta.ingress_global_tstamp','ingress_global_tstamp')
local p4_q_meta__pad1 = ProtoField.string('p4_q_meta._pad1','_pad1')
local p4_q_meta_egress_global_tstamp = ProtoField.string('p4_q_meta.egress_global_tstamp','egress_global_tstamp')
local p4_q_meta__pad2 = ProtoField.string('p4_q_meta._pad2','_pad2')
local p4_q_meta_markbit = ProtoField.string('p4_q_meta.markbit','markbit')
local p4_q_meta__pad3 = ProtoField.string('p4_q_meta._pad3','_pad3')
local p4_q_meta_enq_qdepth = ProtoField.string('p4_q_meta.enq_qdepth','enq_qdepth')
local p4_q_meta__pad4 = ProtoField.string('p4_q_meta._pad4','_pad4')
local p4_q_meta_deq_qdepth = ProtoField.string('p4_q_meta.deq_qdepth','deq_qdepth')
p4_q_meta.fields = {p4_q_meta_flow_id, p4_q_meta__pad0, p4_q_meta_ingress_global_tstamp, p4_q_meta__pad1, p4_q_meta_egress_global_tstamp, p4_q_meta__pad2, p4_q_meta_markbit, p4_q_meta__pad3, p4_q_meta_enq_qdepth, p4_q_meta__pad4, p4_q_meta_deq_qdepth}


-- protocol dissector function
function p4_q_meta.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_Q_META'
	local subtree = tree:add(p4_q_meta,buffer(),'P4_Q_META Protocol Data')
		subtree:add(p4_q_meta_flow_id,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_q_meta__pad0,tostring(buffer(2,2):bitfield(0,16)))
		subtree:add(p4_q_meta_ingress_global_tstamp,tostring(buffer(4,6):bitfield(0,48)))
		subtree:add(p4_q_meta__pad1,tostring(buffer(10,2):bitfield(0,16)))
		subtree:add(p4_q_meta_egress_global_tstamp,tostring(buffer(12,6):bitfield(0,48)))
		subtree:add(p4_q_meta__pad2,tostring(buffer(18,2):bitfield(0,15)))
		subtree:add(p4_q_meta_markbit,tostring(buffer(19,1):bitfield(7,1)))
		subtree:add(p4_q_meta__pad3,tostring(buffer(20,1):bitfield(0,5)))
		subtree:add(p4_q_meta_enq_qdepth,tostring(buffer(20,3):bitfield(5,19)))
		subtree:add(p4_q_meta__pad4,tostring(buffer(23,1):bitfield(0,5)))
		subtree:add(p4_q_meta_deq_qdepth,tostring(buffer(23,3):bitfield(5,19)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x1e61,p4_q_meta)
