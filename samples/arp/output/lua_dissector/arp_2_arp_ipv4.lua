-- protocol naming
p4_arp_ipv4 = Proto('p4_arp_ipv4','P4_ARP_IPV4Protocol')
-- protocol fields
local p4_arp_ipv4_sha = ProtoField.string('p4_arp_ipv4.sha','sha')
local p4_arp_ipv4_spa = ProtoField.string('p4_arp_ipv4.spa','spa')
local p4_arp_ipv4_tha = ProtoField.string('p4_arp_ipv4.tha','tha')
local p4_arp_ipv4_tpa = ProtoField.string('p4_arp_ipv4.tpa','tpa')
p4_arp_ipv4.fields = {p4_arp_ipv4_sha, p4_arp_ipv4_spa, p4_arp_ipv4_tha, p4_arp_ipv4_tpa}


-- protocol dissector function
function p4_arp_ipv4.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ARP_IPV4'
	local subtree = tree:add(p4_arp_ipv4,buffer(),'P4_ARP_IPV4 Protocol Data')
		subtree:add(p4_arp_ipv4_sha,tostring(buffer(0,6):bitfield(0,48)))
		subtree:add(p4_arp_ipv4_spa,tostring(buffer(6,4):bitfield(0,32)))
		subtree:add(p4_arp_ipv4_tha,tostring(buffer(10,6):bitfield(0,48)))
		subtree:add(p4_arp_ipv4_tpa,tostring(buffer(16,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_arp.htype')
my_table:add(0x000108000604,p4_arp_ipv4)

-- creation of table for next layer(if required)
