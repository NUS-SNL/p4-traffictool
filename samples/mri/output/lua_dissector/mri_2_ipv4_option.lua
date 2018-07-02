-- protocol naming
p4_ipv4_option = Proto('p4_ipv4_option','P4_IPV4_OPTIONProtocol')
-- protocol fields
local p4_ipv4_option_copyFlag = ProtoField.string('p4_ipv4_option.copyFlag','copyFlag')
local p4_ipv4_option_optClass = ProtoField.string('p4_ipv4_option.optClass','optClass')
local p4_ipv4_option_option = ProtoField.string('p4_ipv4_option.option','option')
local p4_ipv4_option_optionLength = ProtoField.string('p4_ipv4_option.optionLength','optionLength')
p4_ipv4_option.fields = {p4_ipv4_option_copyFlag, p4_ipv4_option_optClass, p4_ipv4_option_option, p4_ipv4_option_optionLength}


-- protocol dissector function
function p4_ipv4_option.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_OPTION'
	local subtree = tree:add(p4_ipv4_option,buffer(),'P4_IPV4_OPTION Protocol Data')
		subtree:add(p4_ipv4_option_copyFlag,tostring(buffer(0,1):bitfield(0,1)))
		subtree:add(p4_ipv4_option_optClass,tostring(buffer(0,1):bitfield(1,2)))
		subtree:add(p4_ipv4_option_option,tostring(buffer(0,2):bitfield(3,5)))
		subtree:add(p4_ipv4_option_optionLength,tostring(buffer(1,1):bitfield(0,8)))
	local mydissectortable = DissectorTable.get('p4_ipv4_option.option')
	mydissectortable:try(buffer(0,1):bitfield(3,5), buffer:range(2):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.ihl')
my_table:add(default,p4_ipv4_option)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_ipv4_option.option','P4_IPV4_OPTION.OPTION',ftypes.STRING)