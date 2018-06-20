-- protocol naming
p4_proto = Proto('p4_arp','P4_ARPProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ARP'
	local subtree = tree:add(p4_proto,buffer(),'P4_ARP Protocol Data')
		subtree:add(buffer(0,2), 'htype (16 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(0,16))))
		subtree:add(buffer(2,2), 'ptype (16 bits):' .. string.format('%X', tostring(buffer(2,2):bitfield(0,16))))
		subtree:add(buffer(4,1), 'hlen (8 bits):' .. string.format('%X', tostring(buffer(4,1):bitfield(0,8))))
		subtree:add(buffer(5,1), 'plen (8 bits):' .. string.format('%X', tostring(buffer(5,1):bitfield(0,8))))
		subtree:add(buffer(6,2), 'oper (16 bits):' .. string.format('%X', tostring(buffer(6,2):bitfield(0,16))))
	 mydissectortable:try(buffer(0,2):bitfield(0,16), buffer:range(8):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x0806,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_arp.htype','P4_ARP.HTYPE',ftypes.STRING)