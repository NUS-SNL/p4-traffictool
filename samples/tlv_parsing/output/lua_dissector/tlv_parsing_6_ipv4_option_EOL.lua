-- protocol naming
p4_ipv4_option_eol = Proto('p4_ipv4_option_eol','P4_IPV4_OPTION_EOLProtocol')
-- protocol fields
local p4_ipv4_option_eol_value = ProtoField.string('p4_ipv4_option_eol.value','value')
p4_ipv4_option_eol.fields = {p4_ipv4_option_eol_value}


-- protocol dissector function
function p4_ipv4_option_eol.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION_EOL'
	local subtree = tree:add(p4_ipv4_option_eol,buffer(),'P4_IPV4_OPTION_EOL Protocol Data')
		subtree:add(p4_ipv4_option_eol_value,tostring(buffer(0,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
