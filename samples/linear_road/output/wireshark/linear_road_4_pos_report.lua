-- protocol naming
p4_pos_report = Proto('p4_pos_report','P4_POS_REPORTProtocol')

-- protocol fields
local p4_pos_report_time = ProtoField.string('p4_pos_report.time','time')
local p4_pos_report_vid = ProtoField.string('p4_pos_report.vid','vid')
local p4_pos_report_spd = ProtoField.string('p4_pos_report.spd','spd')
local p4_pos_report_xway = ProtoField.string('p4_pos_report.xway','xway')
local p4_pos_report_lane = ProtoField.string('p4_pos_report.lane','lane')
local p4_pos_report_dir = ProtoField.string('p4_pos_report.dir','dir')
local p4_pos_report_seg = ProtoField.string('p4_pos_report.seg','seg')
p4_pos_report.fields = {p4_pos_report_time, p4_pos_report_vid, p4_pos_report_spd, p4_pos_report_xway, p4_pos_report_lane, p4_pos_report_dir, p4_pos_report_seg}


-- protocol dissector function
function p4_pos_report.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_POS_REPORT'
    local subtree = tree:add(p4_pos_report,buffer(),'P4_POS_REPORT Protocol Data')
        subtree:add(p4_pos_report_time,tostring(buffer(0,2):bitfield(0,16)))
        subtree:add(p4_pos_report_vid,tostring(buffer(2,4):bitfield(0,32)))
        subtree:add(p4_pos_report_spd,tostring(buffer(6,1):bitfield(0,8)))
        subtree:add(p4_pos_report_xway,tostring(buffer(7,1):bitfield(0,8)))
        subtree:add(p4_pos_report_lane,tostring(buffer(8,1):bitfield(0,8)))
        subtree:add(p4_pos_report_dir,tostring(buffer(9,1):bitfield(0,8)))
        subtree:add(p4_pos_report_seg,tostring(buffer(10,1):bitfield(0,8)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x00,p4_pos_report)
