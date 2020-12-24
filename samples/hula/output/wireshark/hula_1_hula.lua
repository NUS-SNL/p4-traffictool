-- protocol naming
p4_hula = Proto('p4_hula','P4_HULAProtocol')

-- protocol fields
local p4_hula__pad0 = ProtoField.string('p4_hula._pad0','_pad0')
local p4_hula_dir = ProtoField.string('p4_hula.dir','dir')
local p4_hula__pad1 = ProtoField.string('p4_hula._pad1','_pad1')
local p4_hula_qdepth = ProtoField.string('p4_hula.qdepth','qdepth')
local p4_hula_digest = ProtoField.string('p4_hula.digest','digest')
p4_hula.fields = {p4_hula__pad0, p4_hula_dir, p4_hula__pad1, p4_hula_qdepth, p4_hula_digest}


-- protocol dissector function
function p4_hula.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_HULA'
    local subtree = tree:add(p4_hula,buffer(),'P4_HULA Protocol Data')
        subtree:add(p4_hula__pad0,tostring(buffer(0,1):bitfield(0,7)))
        subtree:add(p4_hula_dir,tostring(buffer(0,1):bitfield(7,1)))
        subtree:add(p4_hula__pad1,tostring(buffer(1,1):bitfield(0,1)))
        subtree:add(p4_hula_qdepth,tostring(buffer(1,2):bitfield(1,15)))
        subtree:add(p4_hula_digest,tostring(buffer(3,4):bitfield(0,32)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('ethertype')
my_table:add(0x2345,p4_hula)
