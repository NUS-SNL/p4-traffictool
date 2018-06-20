-- protocol naming
p4_proto = Proto('p4_snapshot','P4_SNAPSHOTProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_SNAPSHOT'
	local subtree = tree:add(p4_proto,buffer(),'P4_SNAPSHOT Protocol Data')
		subtree:add(buffer(0,2), 'ingress_global_tstamp_hi_16 (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,4), 'ingress_global_tstamp_lo_32 (32 bits):' .. string.format('%X', tostring(buffer(2,4):bitfield(0,32))))
		subtree:add(buffer(6,4), 'egress_global_tstamp_lo_32 (32 bits):' .. string.format('%X', tostring(buffer(6,4):bitfield(0,32))))
		subtree:add(buffer(10,4), 'enq_qdepth (32 bits):' .. string.format('%X', tostring(buffer(10,4):bitfield(0,32))))
		subtree:add(buffer(14,4), 'deq_qdepth (32 bits):' .. string.format('%X', tostring(buffer(14,4):bitfield(0,32))))
		subtree:add(buffer(18,2), '_pad0 (16 bits):' .. string.format('%X', tostring(buffer(18,2):bitfield(0,16))))
		subtree:add(buffer(20,6), 'orig_egress_global_tstamp (48 bits):' .. string.format('%X', tostring(buffer(20,6):bitfield(0,48))))
		subtree:add(buffer(26,2), '_pad1 (16 bits):' .. string.format('%X', tostring(buffer(26,2):bitfield(0,16))))
		subtree:add(buffer(28,6), 'new_egress_global_tstamp (48 bits):' .. string.format('%X', tostring(buffer(28,6):bitfield(0,48))))
		subtree:add(buffer(34,4), 'new_enq_tstamp (32 bits):' .. string.format('%X', tostring(buffer(34,4):bitfield(0,32))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x22b8,p4_proto)

-- creation of table for next layer(if required)
