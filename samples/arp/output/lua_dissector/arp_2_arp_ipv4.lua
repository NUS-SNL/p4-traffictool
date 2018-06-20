-- protocol naming
p4_proto = Proto('p4_arp_ipv4','P4_ARP_IPV4Protocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ARP_IPV4'
	local subtree = tree:add(p4_proto,buffer(),'P4_ARP_IPV4 Protocol Data')
		subtree:add(buffer(0,6), 'sha (48 bits):' .. string.format('%X', tostring(buffer(0,6):bitfield(0,48))))
		subtree:add(buffer(6,4), 'spa (32 bits):' .. string.format('%X', tostring(buffer(6,4):bitfield(0,32))))
		subtree:add(buffer(10,6), 'tha (48 bits):' .. string.format('%X', tostring(buffer(10,6):bitfield(0,48))))
		subtree:add(buffer(16,4), 'tpa (32 bits):' .. string.format('%X', tostring(buffer(16,4):bitfield(0,32))))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_arp.htype')
my_table:add(0x000108000604,p4_proto)

-- creation of table for next layer(if required)
