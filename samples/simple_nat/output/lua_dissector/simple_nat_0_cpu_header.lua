-- protocol naming
p4_cpu_header = Proto('p4_cpu_header','P4_CPU_HEADERProtocol')
-- protocol fields
local p4_cpu_header_preamble = ProtoField.string('p4_cpu_header.preamble','preamble')
local p4_cpu_header_device = ProtoField.string('p4_cpu_header.device','device')
local p4_cpu_header_reason = ProtoField.string('p4_cpu_header.reason','reason')
local p4_cpu_header_if_index = ProtoField.string('p4_cpu_header.if_index','if_index')
p4_cpu_header.fields = {p4_cpu_header_preamble, p4_cpu_header_device, p4_cpu_header_reason, p4_cpu_header_if_index}


-- protocol dissector function
function p4_cpu_header.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_CPU_HEADER'
	local subtree = tree:add(p4_cpu_header,buffer(),'P4_CPU_HEADER Protocol Data')
		subtree:add(p4_cpu_header_preamble,tostring(buffer(0,8):bitfield(0,64)))
		subtree:add(p4_cpu_header_device,tostring(buffer(8,1):bitfield(0,8)))
		subtree:add(p4_cpu_header_reason,tostring(buffer(9,1):bitfield(0,8)))
		subtree:add(p4_cpu_header_if_index,tostring(buffer(10,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
