-- protocol naming
p4_ipv4_option_timestamp = Proto('p4_ipv4_option_timestamp','P4_IPV4_OPTION_TIMESTAMPProtocol')
-- protocol fields
local p4_ipv4_option_timestamp_value = ProtoField.string('p4_ipv4_option_timestamp.value','value')
local p4_ipv4_option_timestamp_len = ProtoField.string('p4_ipv4_option_timestamp.len','len')
local p4_ipv4_option_timestamp_data = ProtoField.string('p4_ipv4_option_timestamp.data','data')
p4_ipv4_option_timestamp.fields = {p4_ipv4_option_timestamp_value, p4_ipv4_option_timestamp_len, p4_ipv4_option_timestamp_data}


-- protocol dissector function
function p4_ipv4_option_timestamp.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION_TIMESTAMP'
	local subtree = tree:add(p4_ipv4_option_timestamp,buffer(),'P4_IPV4_OPTION_TIMESTAMP Protocol Data')
		subtree:add(p4_ipv4_option_timestamp_value,tostring(buffer(0,1):bitfield(0,8)))
		subtree:add(p4_ipv4_option_timestamp_len,tostring(buffer(1,1):bitfield(0,8)))
		subtree:add(p4_ipv4_option_timestamp_data,tostring(buffer(2,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
