-- protocol naming
p4_tcp = Proto('p4_tcp','P4_TCPProtocol')
-- protocol fields
local p4_tcp_srcPort = ProtoField.string('p4_tcp.srcPort','srcPort')
local p4_tcp_dstPort = ProtoField.string('p4_tcp.dstPort','dstPort')
local p4_tcp_seqNo = ProtoField.string('p4_tcp.seqNo','seqNo')
local p4_tcp_ackNo = ProtoField.string('p4_tcp.ackNo','ackNo')
local p4_tcp_dataOffset = ProtoField.string('p4_tcp.dataOffset','dataOffset')
local p4_tcp_res = ProtoField.string('p4_tcp.res','res')
local p4_tcp_flags = ProtoField.string('p4_tcp.flags','flags')
local p4_tcp_window = ProtoField.string('p4_tcp.window','window')
local p4_tcp_checksum = ProtoField.string('p4_tcp.checksum','checksum')
local p4_tcp_urgentPtr = ProtoField.string('p4_tcp.urgentPtr','urgentPtr')
p4_tcp.fields = {p4_tcp_srcPort, p4_tcp_dstPort, p4_tcp_seqNo, p4_tcp_ackNo, p4_tcp_dataOffset, p4_tcp_res, p4_tcp_flags, p4_tcp_window, p4_tcp_checksum, p4_tcp_urgentPtr}


-- protocol dissector function
function p4_tcp.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TCP'
	local subtree = tree:add(p4_tcp,buffer(),'P4_TCP Protocol Data')
		subtree:add(p4_tcp_srcPort,tostring(buffer(0,2):bitfield(0,16)))
		subtree:add(p4_tcp_dstPort,tostring(buffer(2,2):bitfield(0,16)))
		subtree:add(p4_tcp_seqNo,tostring(buffer(4,4):bitfield(0,32)))
		subtree:add(p4_tcp_ackNo,tostring(buffer(8,4):bitfield(0,32)))
		subtree:add(p4_tcp_dataOffset,tostring(buffer(12,1):bitfield(0,4)))
		subtree:add(p4_tcp_res,tostring(buffer(12,2):bitfield(4,4)))
		subtree:add(p4_tcp_flags,tostring(buffer(13,1):bitfield(0,8)))
		subtree:add(p4_tcp_window,tostring(buffer(14,2):bitfield(0,16)))
		subtree:add(p4_tcp_checksum,tostring(buffer(16,2):bitfield(0,16)))
		subtree:add(p4_tcp_urgentPtr,tostring(buffer(18,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration
my_table = DissectorTable.get('p4_ipv4.protocol')
my_table:add(0x06,p4_tcp)

-- creation of table for next layer(if required)
