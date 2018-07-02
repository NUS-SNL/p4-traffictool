-- protocol naming
p4_ipv4_base = Proto('p4_ipv4_base','P4_IPV4_BASEProtocol')
-- protocol fields
local p4_ipv4_base_version = ProtoField.string('p4_ipv4_base.version','version')
local p4_ipv4_base_ihl = ProtoField.string('p4_ipv4_base.ihl','ihl')
local p4_ipv4_base_diffserv = ProtoField.string('p4_ipv4_base.diffserv','diffserv')
local p4_ipv4_base_totalLen = ProtoField.string('p4_ipv4_base.totalLen','totalLen')
local p4_ipv4_base_identification = ProtoField.string('p4_ipv4_base.identification','identification')
local p4_ipv4_base_flags = ProtoField.string('p4_ipv4_base.flags','flags')
local p4_ipv4_base_fragOffset = ProtoField.string('p4_ipv4_base.fragOffset','fragOffset')
local p4_ipv4_base_ttl = ProtoField.string('p4_ipv4_base.ttl','ttl')
local p4_ipv4_base_protocol = ProtoField.string('p4_ipv4_base.protocol','protocol')
local p4_ipv4_base_hdrChecksum = ProtoField.string('p4_ipv4_base.hdrChecksum','hdrChecksum')
local p4_ipv4_base_srcAddr = ProtoField.string('p4_ipv4_base.srcAddr','srcAddr')
local p4_ipv4_base_dstAddr = ProtoField.string('p4_ipv4_base.dstAddr','dstAddr')
p4_ipv4_base.fields = {p4_ipv4_base_version, p4_ipv4_base_ihl, p4_ipv4_base_diffserv, p4_ipv4_base_totalLen, p4_ipv4_base_identification, p4_ipv4_base_flags, p4_ipv4_base_fragOffset, p4_ipv4_base_ttl, p4_ipv4_base_protocol, p4_ipv4_base_hdrChecksum, p4_ipv4_base_srcAddr, p4_ipv4_base_dstAddr}


-- protocol dissector function
function p4_ipv4_base.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_IPV4_BASE'
	local subtree = tree:add(p4_ipv4_base,buffer(),'P4_IPV4_BASE Protocol Data')
		subtree:add(p4_ipv4_base_version,tostring(buffer(0,1):bitfield(0,4)))
		subtree:add(p4_ipv4_base_ihl,tostring(buffer(0,2):bitfield(4,4)))
		subtree:add(p4_ipv4_base_diffserv,tostring(buffer(1,1):bitfield(0,8)))
		subtree:add(p4_ipv4_base_totalLen,tostring(buffer(2,2):bitfield(0,16)))
		subtree:add(p4_ipv4_base_identification,tostring(buffer(4,2):bitfield(0,16)))
		subtree:add(p4_ipv4_base_flags,tostring(buffer(6,1):bitfield(0,3)))
		subtree:add(p4_ipv4_base_fragOffset,tostring(buffer(6,3):bitfield(3,13)))
		subtree:add(p4_ipv4_base_ttl,tostring(buffer(8,1):bitfield(0,8)))
		subtree:add(p4_ipv4_base_protocol,tostring(buffer(9,1):bitfield(0,8)))
		subtree:add(p4_ipv4_base_hdrChecksum,tostring(buffer(10,2):bitfield(0,16)))
		subtree:add(p4_ipv4_base_srcAddr,tostring(buffer(12,4):bitfield(0,32)))
		subtree:add(p4_ipv4_base_dstAddr,tostring(buffer(16,4):bitfield(0,32)))
	local mydissectortable = DissectorTable.get('p4_ipv4_base.ihl')
	mydissectortable:try(buffer(0,1):bitfield(4,4), buffer:range(20):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x0800,p4_ipv4_base)

-- creation of table for next layer(if required)

local newdissectortable = DissectorTable.new('p4_ipv4_base.ihl','P4_IPV4_BASE.IHL',ftypes.STRING)