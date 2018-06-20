-- protocol naming
p4_proto = Proto('p4_cpu_header','P4_CPU_HEADERProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_CPU_HEADER'
	local subtree = tree:add(p4_proto,buffer(),'P4_CPU_HEADER Protocol Data')
		subtree:add(buffer(0,8), 'preamble (64 bits):' .. string.format('%X', tostring(buffer(0,8):bitfield(0,64))))
		subtree:add(buffer(8,1), 'device (8 bits):' .. string.format('%X', tostring(buffer(8,1):bitfield(0,8))))
		subtree:add(buffer(9,1), 'reason (8 bits):' .. string.format('%X', tostring(buffer(9,1):bitfield(0,8))))
		subtree:add(buffer(10,1), 'if_index (8 bits):' .. string.format('%X', tostring(buffer(10,1):bitfield(0,8))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
