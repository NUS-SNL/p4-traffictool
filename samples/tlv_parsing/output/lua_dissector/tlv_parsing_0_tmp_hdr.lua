-- protocol naming
p4_tmp_hdr = Proto('p4_tmp_hdr','P4_TMP_HDRProtocol')
-- protocol fields
local p4_tmp_hdr_value = ProtoField.string('p4_tmp_hdr.value','value')
local p4_tmp_hdr_len = ProtoField.string('p4_tmp_hdr.len','len')
p4_tmp_hdr.fields = {p4_tmp_hdr_value, p4_tmp_hdr_len}


-- protocol dissector function
function p4_tmp_hdr.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TMP_HDR'
	local subtree = tree:add(p4_tmp_hdr,buffer(),'P4_TMP_HDR Protocol Data')
		subtree:add(p4_tmp_hdr_value,tostring(buffer(0,1):bitfield(0,8)))
		subtree:add(p4_tmp_hdr_len,tostring(buffer(1,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- protocol registration

-- creation of table for next layer(if required)
