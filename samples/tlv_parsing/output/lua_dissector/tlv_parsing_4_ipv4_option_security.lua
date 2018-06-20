-- protocol naming
p4_proto = Proto('p4_ipv4_option_security','P4_IPV4_OPTION_SECURITYProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION_SECURITY'
	local subtree = tree:add(p4_proto,buffer(),'P4_IPV4_OPTION_SECURITY Protocol Data')
		subtree:add(buffer(0,1), 'value (8 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,8))))
		subtree:add(buffer(1,1), 'len (8 bits):' .. string.format('%X', tostring(buffer(1,1):bitfield(0,8))))
		subtree:add(buffer(2,9), 'security (72 bits):' .. string.format('%X', tostring(buffer(2,9):bitfield(0,72))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
