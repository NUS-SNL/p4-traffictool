-- protocol naming
p4_proto = Proto('p4_ipv4_option','P4_IPV4_OPTIONProtocol')

-- protocol dissector function
function p4_proto.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION'
	local subtree = tree:add(p4_proto,buffer(),'P4_IPV4_OPTION Protocol Data')
		subtree:add(buffer(0,1), 'copyFlag (1 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(0,1))))
		subtree:add(buffer(0,1), 'optClass (2 bits):' .. string.format('%X', tostring(buffer(0,1):bitfield(1,2))))
		subtree:add(buffer(0,2), 'option (5 bits):' .. string.format('%X', tostring(buffer(0,2):bitfield(3,5))))
		subtree:add(buffer(1,1), 'optionLength (8 bits):' .. string.format('%X', tostring(buffer(1,1):bitfield(0,8))))
	local mydissectortable = DissectorTable.get('p4_ipv4_option.option')
	mydissectortable:try(buffer(0,1):bitfield(3,5), buffer:range(2):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.ihl')
my_table:add(default,p4_proto)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_ipv4_option.option','P4_IPV4_OPTION.OPTION',ftypes.STRING)