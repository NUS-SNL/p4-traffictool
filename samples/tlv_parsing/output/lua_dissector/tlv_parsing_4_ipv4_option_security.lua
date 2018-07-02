-- protocol naming
p4_ipv4_option_security = Proto('p4_ipv4_option_security','P4_IPV4_OPTION_SECURITYProtocol')
-- protocol fields
local p4_ipv4_option_security_value = ProtoField.string('p4_ipv4_option_security.value','value')
local p4_ipv4_option_security_len = ProtoField.string('p4_ipv4_option_security.len','len')
local p4_ipv4_option_security_security = ProtoField.string('p4_ipv4_option_security.security','security')
p4_ipv4_option_security.fields = {p4_ipv4_option_security_value, p4_ipv4_option_security_len, p4_ipv4_option_security_security}


-- protocol dissector function
function p4_ipv4_option_security.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION_SECURITY'
	local subtree = tree:add(p4_ipv4_option_security,buffer(),'P4_IPV4_OPTION_SECURITY Protocol Data')
		subtree:add(p4_ipv4_option_security_value,tostring(buffer(0,1):bitfield(0,8)))
		subtree:add(p4_ipv4_option_security_len,tostring(buffer(1,1):bitfield(0,8)))
		subtree:add(p4_ipv4_option_security_security,tostring(buffer(2,9):bitfield(0,72)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
