-- protocol naming
p4_tmp_hdr_0 = Proto('p4_tmp_hdr_0','P4_TMP_HDR_0Protocol')
-- protocol fields
local p4_tmp_hdr_0_data = ProtoField.string('p4_tmp_hdr_0.data','data')
p4_tmp_hdr_0.fields = {p4_tmp_hdr_0_data}


-- protocol dissector function
function p4_tmp_hdr_0.dissector(buffer,pinfo,tree)
	pinfo.cols.protocol = 'P4_TMP_HDR_0'
	local subtree = tree:add(p4_tmp_hdr_0,buffer(),'P4_TMP_HDR_0 Protocol Data')
