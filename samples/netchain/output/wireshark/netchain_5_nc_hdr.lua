-- protocol naming
p4_nc_hdr = Proto('p4_nc_hdr','P4_NC_HDRProtocol')

-- protocol fields
local p4_nc_hdr_op = ProtoField.string('p4_nc_hdr.op','op')
local p4_nc_hdr_sc = ProtoField.string('p4_nc_hdr.sc','sc')
local p4_nc_hdr_seq = ProtoField.string('p4_nc_hdr.seq','seq')
local p4_nc_hdr_key = ProtoField.string('p4_nc_hdr.key','key')
local p4_nc_hdr_value = ProtoField.string('p4_nc_hdr.value','value')
local p4_nc_hdr_vgroup = ProtoField.string('p4_nc_hdr.vgroup','vgroup')
p4_nc_hdr.fields = {p4_nc_hdr_op, p4_nc_hdr_sc, p4_nc_hdr_seq, p4_nc_hdr_key, p4_nc_hdr_value, p4_nc_hdr_vgroup}


-- protocol dissector function
function p4_nc_hdr.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_NC_HDR'
    local subtree = tree:add(p4_nc_hdr,buffer(),'P4_NC_HDR Protocol Data')
        subtree:add(p4_nc_hdr_op,tostring(buffer(0,1):bitfield(0,8)))
        subtree:add(p4_nc_hdr_sc,tostring(buffer(1,1):bitfield(0,8)))
        subtree:add(p4_nc_hdr_seq,tostring(buffer(2,2):bitfield(0,16)))
        subtree:add(p4_nc_hdr_key,tostring(buffer(4,8):bitfield(0,64)))
        subtree:add(p4_nc_hdr_value,tostring(buffer(12,8):bitfield(0,64)))
        subtree:add(p4_nc_hdr_vgroup,tostring(buffer(20,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_overlay.swip')
my_table:add(0x00000000,p4_nc_hdr)
