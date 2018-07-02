-- protocol naming
p4_icmp = Proto('p4_icmp','P4_ICMPProtocol')
-- protocol fields
local p4_icmp_type = ProtoField.string('p4_icmp.type','type')
local p4_icmp_code = ProtoField.string('p4_icmp.code','code')
local p4_icmp_checksum = ProtoField.string('p4_icmp.checksum','checksum')
p4_icmp.fields = {p4_icmp_type, p4_icmp_code, p4_icmp_checksum}


-- protocol dissector function
function p4_icmp.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ICMP'
	local subtree = tree:add(p4_icmp,buffer(),'P4_ICMP Protocol Data')
		subtree:add(p4_icmp_type,tostring(buffer(0,1):bitfield(0,8)))
		subtree:add(p4_icmp_code,tostring(buffer(1,1):bitfield(0,8)))
		subtree:add(p4_icmp_checksum,tostring(buffer(2,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x01,p4_icmp)

-- creation of table for next layer(if required)
