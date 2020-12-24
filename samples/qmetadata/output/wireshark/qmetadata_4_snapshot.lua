-- protocol naming
p4_snapshot = Proto('p4_snapshot','P4_SNAPSHOTProtocol')

-- protocol fields
local p4_snapshot_ingress_global_tstamp_hi_16 = ProtoField.string('p4_snapshot.ingress_global_tstamp_hi_16','ingress_global_tstamp_hi_16')
local p4_snapshot_ingress_global_tstamp_lo_32 = ProtoField.string('p4_snapshot.ingress_global_tstamp_lo_32','ingress_global_tstamp_lo_32')
local p4_snapshot_egress_global_tstamp_lo_32 = ProtoField.string('p4_snapshot.egress_global_tstamp_lo_32','egress_global_tstamp_lo_32')
local p4_snapshot_enq_qdepth = ProtoField.string('p4_snapshot.enq_qdepth','enq_qdepth')
local p4_snapshot_deq_qdepth = ProtoField.string('p4_snapshot.deq_qdepth','deq_qdepth')
local p4_snapshot__pad0 = ProtoField.string('p4_snapshot._pad0','_pad0')
local p4_snapshot_orig_egress_global_tstamp = ProtoField.string('p4_snapshot.orig_egress_global_tstamp','orig_egress_global_tstamp')
local p4_snapshot__pad1 = ProtoField.string('p4_snapshot._pad1','_pad1')
local p4_snapshot_new_egress_global_tstamp = ProtoField.string('p4_snapshot.new_egress_global_tstamp','new_egress_global_tstamp')
local p4_snapshot_new_enq_tstamp = ProtoField.string('p4_snapshot.new_enq_tstamp','new_enq_tstamp')
p4_snapshot.fields = {p4_snapshot_ingress_global_tstamp_hi_16, p4_snapshot_ingress_global_tstamp_lo_32, p4_snapshot_egress_global_tstamp_lo_32, p4_snapshot_enq_qdepth, p4_snapshot_deq_qdepth, p4_snapshot__pad0, p4_snapshot_orig_egress_global_tstamp, p4_snapshot__pad1, p4_snapshot_new_egress_global_tstamp, p4_snapshot_new_enq_tstamp}


-- protocol dissector function
function p4_snapshot.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_SNAPSHOT'
    local subtree = tree:add(p4_snapshot,buffer(),'P4_SNAPSHOT Protocol Data')
        subtree:add(p4_snapshot_ingress_global_tstamp_hi_16,tostring(buffer(0,2):bitfield(0,16)))
        subtree:add(p4_snapshot_ingress_global_tstamp_lo_32,tostring(buffer(2,4):bitfield(0,32)))
        subtree:add(p4_snapshot_egress_global_tstamp_lo_32,tostring(buffer(6,4):bitfield(0,32)))
        subtree:add(p4_snapshot_enq_qdepth,tostring(buffer(10,4):bitfield(0,32)))
        subtree:add(p4_snapshot_deq_qdepth,tostring(buffer(14,4):bitfield(0,32)))
        subtree:add(p4_snapshot__pad0,tostring(buffer(18,2):bitfield(0,16)))
        subtree:add(p4_snapshot_orig_egress_global_tstamp,tostring(buffer(20,6):bitfield(0,48)))
        subtree:add(p4_snapshot__pad1,tostring(buffer(26,2):bitfield(0,16)))
        subtree:add(p4_snapshot_new_egress_global_tstamp,tostring(buffer(28,6):bitfield(0,48)))
        subtree:add(p4_snapshot_new_enq_tstamp,tostring(buffer(34,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x22b8,p4_snapshot)
