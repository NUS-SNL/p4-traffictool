-- protocol naming
p4_arp = Proto('p4_arp','P4_ARPProtocol')
-- protocol fields
local p4_arp_htype = ProtoField.string('p4_arp.htype','htype')
local p4_arp_ptype = ProtoField.string('p4_arp.ptype','ptype')
local p4_arp_hlen = ProtoField.string('p4_arp.hlen','hlen')
local p4_arp_plen = ProtoField.string('p4_arp.plen','plen')
local p4_arp_oper = ProtoField.string('p4_arp.oper','oper')
p4_arp.fields = {p4_arp_htype, p4_arp_ptype, p4_arp_hlen, p4_arp_plen, p4_arp_oper}


-- protocol dissector function
function p4_arp.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_ARP'
	local subtree = tree:add(p4_arp,buffer(),'P4_ARP Protocol Data')
		subtree:add(p4_arp_htype,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_arp_ptype,tostring(buffer(2,2):bitfield(0,16)))
		subtree:add(p4_arp_hlen,tostring(buffer(4,1):bitfield(0,8)))
		subtree:add(p4_arp_plen,tostring(buffer(5,1):bitfield(0,8)))
		subtree:add(p4_arp_oper,tostring(buffer(6,2):bitfield(0,16)))
	local mydissectortable = DissectorTable.get('p4_arp.htype')
	mydissectortable:try(buffer(0,2):bitfield(0,16), buffer:range(8):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x0806,p4_arp)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_arp.htype','P4_ARP.HTYPE',ftypes.STRING)