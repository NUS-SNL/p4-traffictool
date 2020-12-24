-- protocol naming
p4_nc_hdr = Proto('p4_nc_hdr','P4_NC_HDRProtocol')

-- protocol fields
local p4_nc_hdr_op = ProtoField.string('p4_nc_hdr.op','op')
local p4_nc_hdr_key = ProtoField.string('p4_nc_hdr.key','key')
p4_nc_hdr.fields = {p4_nc_hdr_op, p4_nc_hdr_key}


-- protocol dissector function
function p4_nc_hdr.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_NC_HDR'
    local subtree = tree:add(p4_nc_hdr,buffer(),'P4_NC_HDR Protocol Data')
        subtree:add(p4_nc_hdr_op,tostring(buffer(0,1):bitfield(0,8)))
        subtree:add(p4_nc_hdr_key,tostring(buffer(1,8):bitfield(0,64)))
    local mydissectortable = DissectorTable.get('p4_nc_hdr.op')
    mydissectortable:try(buffer(0,1):bitfield(0,8), buffer:range(9):tvb(),pinfo,tree)

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)
local newdissectortable = DissectorTable.new('p4_nc_hdr.op','P4_NC_HDR.OP',ftypes.STRING)

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x22b8,p4_nc_hdr)
