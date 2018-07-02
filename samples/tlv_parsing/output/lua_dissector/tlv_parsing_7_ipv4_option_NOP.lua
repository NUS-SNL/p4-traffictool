-- protocol naming
p4_ipv4_option_nop = Proto('p4_ipv4_option_nop','P4_IPV4_OPTION_NOPProtocol')
-- protocol fields
local p4_ipv4_option_nop_value = ProtoField.string('p4_ipv4_option_nop.value','value')
p4_ipv4_option_nop.fields = {p4_ipv4_option_nop_value}


-- protocol dissector function
function p4_ipv4_option_nop.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION_NOP'
	local subtree = tree:add(p4_ipv4_option_nop,buffer(),'P4_IPV4_OPTION_NOP Protocol Data')
		subtree:add(p4_ipv4_option_nop_value,tostring(buffer(0,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
