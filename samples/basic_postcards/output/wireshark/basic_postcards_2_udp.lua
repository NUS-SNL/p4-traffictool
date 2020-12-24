-- protocol naming
p4_udp = Proto('p4_udp','P4_UDPProtocol')

-- protocol fields
local p4_udp_src_port = ProtoField.string('p4_udp.src_port','src_port')
local p4_udp_dst_port = ProtoField.string('p4_udp.dst_port','dst_port')
local p4_udp_len = ProtoField.string('p4_udp.len','len')
local p4_udp_checksum = ProtoField.string('p4_udp.checksum','checksum')
p4_udp.fields = {p4_udp_src_port, p4_udp_dst_port, p4_udp_len, p4_udp_checksum}


-- protocol dissector function
function p4_udp.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_UDP'
    local subtree = tree:add(p4_udp,buffer(),'P4_UDP Protocol Data')
        subtree:add(p4_udp_src_port,tostring(buffer(0,2):bitfield(0,16)))
        subtree:add(p4_udp_dst_port,tostring(buffer(2,2):bitfield(0,16)))
        subtree:add(p4_udp_len,tostring(buffer(4,2):bitfield(0,16)))
        subtree:add(p4_udp_checksum,tostring(buffer(6,2):bitfield(0,16)))
    local mydissectortable = DissectorTable.get('p4_udp.dst_port')
    mydissectortable:try(buffer(2,2):bitfield(0,16), buffer:range(8):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_udp.dst_port','P4_UDP.DST_PORT',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x11,p4_udp)
