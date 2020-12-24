-- protocol naming
p4_hdr_meta = Proto('p4_hdr_meta','P4_HDR_METAProtocol')

-- protocol fields
local p4_hdr_meta_mac_dstAddr = ProtoField.string('p4_hdr_meta.mac_dstAddr','mac_dstAddr')
local p4_hdr_meta_mac_srcAddr = ProtoField.string('p4_hdr_meta.mac_srcAddr','mac_srcAddr')
local p4_hdr_meta_ip_srcAddr = ProtoField.string('p4_hdr_meta.ip_srcAddr','ip_srcAddr')
local p4_hdr_meta_ip_dstAddr = ProtoField.string('p4_hdr_meta.ip_dstAddr','ip_dstAddr')
local p4_hdr_meta_ip_protocol = ProtoField.string('p4_hdr_meta.ip_protocol','ip_protocol')
p4_hdr_meta.fields = {p4_hdr_meta_mac_dstAddr, p4_hdr_meta_mac_srcAddr, p4_hdr_meta_ip_srcAddr, p4_hdr_meta_ip_dstAddr, p4_hdr_meta_ip_protocol}


-- protocol dissector function
function p4_hdr_meta.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_HDR_META'
    local subtree = tree:add(p4_hdr_meta,buffer(),'P4_HDR_META Protocol Data')
        subtree:add(p4_hdr_meta_mac_dstAddr,tostring(buffer(0,6):bitfield(0,48)))
        subtree:add(p4_hdr_meta_mac_srcAddr,tostring(buffer(6,6):bitfield(0,48)))
        subtree:add(p4_hdr_meta_ip_srcAddr,tostring(buffer(12,4):bitfield(0,32)))
        subtree:add(p4_hdr_meta_ip_dstAddr,tostring(buffer(16,4):bitfield(0,32)))
        subtree:add(p4_hdr_meta_ip_protocol,tostring(buffer(20,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_udp.dst_port')
my_table:add(0x270f,p4_hdr_meta)
