-- protocol naming
p4_paxos = Proto('p4_paxos','P4_PAXOSProtocol')

-- protocol fields
local p4_paxos_msgtype = ProtoField.string('p4_paxos.msgtype','msgtype')
local p4_paxos_instance = ProtoField.string('p4_paxos.instance','instance')
local p4_paxos_round = ProtoField.string('p4_paxos.round','round')
local p4_paxos_vround = ProtoField.string('p4_paxos.vround','vround')
local p4_paxos_acceptor = ProtoField.string('p4_paxos.acceptor','acceptor')
local p4_paxos_value = ProtoField.string('p4_paxos.value','value')
p4_paxos.fields = {p4_paxos_msgtype, p4_paxos_instance, p4_paxos_round, p4_paxos_vround, p4_paxos_acceptor, p4_paxos_value}


-- protocol dissector function
function p4_paxos.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_PAXOS'
    local subtree = tree:add(p4_paxos,buffer(),'P4_PAXOS Protocol Data')
        subtree:add(p4_paxos_msgtype,tostring(buffer(0,1):bitfield(0,8)))
        subtree:add(p4_paxos_instance,tostring(buffer(1,2):bitfield(0,16)))
        subtree:add(p4_paxos_round,tostring(buffer(3,1):bitfield(0,8)))
        subtree:add(p4_paxos_vround,tostring(buffer(4,1):bitfield(0,8)))
        subtree:add(p4_paxos_acceptor,tostring(buffer(5,8):bitfield(0,64)))
        subtree:add(p4_paxos_value,tostring(buffer(13,64):bitfield(0,512)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_udp.dstPort')
my_table:add(0x8888,p4_paxos)
