-- protocol naming
p4_proto = Proto('p4_tmp_hdr_0','P4_TMP_HDR_0Protocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TMP_HDR_0'
	local subtree = tree:add(p4_proto,buffer(),'P4_TMP_HDR_0 Protocol Data')
		subtree:add(buffer(0,1), 'data (8 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,8))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
