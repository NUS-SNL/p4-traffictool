-- protocol naming
p4_proto = Proto('p4_q_meta','P4_Q_METAProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_Q_META'
	local subtree = tree:add(p4_proto,buffer(),'P4_Q_META Protocol Data')
		subtree:add(buffer(0,2), 'flow_id (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,2), '_pad0 (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
		subtree:add(buffer(4,6), 'ingress_global_tstamp (48 bits):' .. string.format('%X', tostring(buffer(4,6):bitfield(0,48))))
		subtree:add(buffer(10,2), '_pad1 (16 bits):' .. string.format('%X', tostring(buffer(10,2):bitfield(0,16))))
		subtree:add(buffer(12,6), 'egress_global_tstamp (48 bits):' .. string.format('%X', tostring(buffer(12,6):bitfield(0,48))))
		subtree:add(buffer(18,2), '_spare_pad_bits (15 bits):' .. string.format('%X', tostring(buffer(18,2):bitfield(0,15))))
		subtree:add(buffer(19,2), 'markbit (1 bits):' .. string.format('%X', tostring(buffer(19,2):bitfield(7,1))))
		subtree:add(buffer(20,2), '_pad2 (13 bits):' .. string.format('%X', tostring(buffer(20,2):bitfield(0,13))))
		subtree:add(buffer(21,4), 'enq_qdepth (19 bits):' .. string.format('%X', tostring(buffer(21,4):bitfield(5,19))))
		subtree:add(buffer(24,2), '_pad3 (13 bits):' .. string.format('%X', tostring(buffer(24,2):bitfield(0,13))))
		subtree:add(buffer(25,4), 'deq_qdepth (19 bits):' .. string.format('%X', tostring(buffer(25,4):bitfield(5,19))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x1e61,p4_proto)

-- creation of table for next layer(if required)
