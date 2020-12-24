-- protocol naming
p4_ipv4 = Proto('p4_ipv4','P4_IPV4Protocol')

-- protocol fields
local p4_ipv4_version = ProtoField.string('p4_ipv4.version','version')
local p4_ipv4_ihl = ProtoField.string('p4_ipv4.ihl','ihl')
local p4_ipv4_diffserv = ProtoField.string('p4_ipv4.diffserv','diffserv')
local p4_ipv4_totalLen = ProtoField.string('p4_ipv4.totalLen','totalLen')
local p4_ipv4_identification = ProtoField.string('p4_ipv4.identification','identification')
local p4_ipv4_flags = ProtoField.string('p4_ipv4.flags','flags')
local p4_ipv4_fragOffset = ProtoField.string('p4_ipv4.fragOffset','fragOffset')
local p4_ipv4_ttl = ProtoField.string('p4_ipv4.ttl','ttl')
local p4_ipv4_protocol = ProtoField.string('p4_ipv4.protocol','protocol')
local p4_ipv4_hdrChecksum = ProtoField.string('p4_ipv4.hdrChecksum','hdrChecksum')
local p4_ipv4_srcAddr = ProtoField.string('p4_ipv4.srcAddr','srcAddr')
local p4_ipv4_dstAddr = ProtoField.string('p4_ipv4.dstAddr','dstAddr')
p4_ipv4.fields = {p4_ipv4_version, p4_ipv4_ihl, p4_ipv4_diffserv, p4_ipv4_totalLen, p4_ipv4_identification, p4_ipv4_flags, p4_ipv4_fragOffset, p4_ipv4_ttl, p4_ipv4_protocol, p4_ipv4_hdrChecksum, p4_ipv4_srcAddr, p4_ipv4_dstAddr}


-- protocol dissector function
function p4_ipv4.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_IPV4'
    local subtree = tree:add(p4_ipv4,buffer(),'P4_IPV4 Protocol Data')
        subtree:add(p4_ipv4_version,tostring(buffer(0,1):bitfield(0,4)))
        subtree:add(p4_ipv4_ihl,tostring(buffer(0,1):bitfield(4,4)))
        subtree:add(p4_ipv4_diffserv,tostring(buffer(1,1):bitfield(0,8)))
        subtree:add(p4_ipv4_totalLen,tostring(buffer(2,2):bitfield(0,16)))
        subtree:add(p4_ipv4_identification,tostring(buffer(4,2):bitfield(0,16)))
        subtree:add(p4_ipv4_flags,tostring(buffer(6,1):bitfield(0,3)))
        subtree:add(p4_ipv4_fragOffset,tostring(buffer(6,2):bitfield(3,13)))
        subtree:add(p4_ipv4_ttl,tostring(buffer(8,1):bitfield(0,8)))
        subtree:add(p4_ipv4_protocol,tostring(buffer(9,1):bitfield(0,8)))
        subtree:add(p4_ipv4_hdrChecksum,tostring(buffer(10,2):bitfield(0,16)))
        subtree:add(p4_ipv4_srcAddr,tostring(buffer(12,4):bitfield(0,32)))
        subtree:add(p4_ipv4_dstAddr,tostring(buffer(16,4):bitfield(0,32)))
    local mydissectortable = DissectorTable.get('p4_ipv4.ihl')
    mydissectortable:try(buffer(0,1):bitfield(4,4), buffer:range(20):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_ipv4.ihl','P4_IPV4.IHL',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x0800,p4_ipv4)
