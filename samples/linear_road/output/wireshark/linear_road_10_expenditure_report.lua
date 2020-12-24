-- protocol naming
p4_expenditure_report = Proto('p4_expenditure_report','P4_EXPENDITURE_REPORTProtocol')

-- protocol fields
local p4_expenditure_report_time = ProtoField.string('p4_expenditure_report.time','time')
local p4_expenditure_report_emit = ProtoField.string('p4_expenditure_report.emit','emit')
local p4_expenditure_report_qid = ProtoField.string('p4_expenditure_report.qid','qid')
local p4_expenditure_report_bal = ProtoField.string('p4_expenditure_report.bal','bal')
p4_expenditure_report.fields = {p4_expenditure_report_time, p4_expenditure_report_emit, p4_expenditure_report_qid, p4_expenditure_report_bal}


-- protocol dissector function
function p4_expenditure_report.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = 'P4_EXPENDITURE_REPORT'
    local subtree = tree:add(p4_expenditure_report,buffer(),'P4_EXPENDITURE_REPORT Protocol Data')
        subtree:add(p4_expenditure_report_time,tostring(buffer(0,2):bitfield(0,16)))
        subtree:add(p4_expenditure_report_emit,tostring(buffer(2,2):bitfield(0,16)))
        subtree:add(p4_expenditure_report_qid,tostring(buffer(4,4):bitfield(0,32)))
        subtree:add(p4_expenditure_report_bal,tostring(buffer(8,2):bitfield(0,16)))

end

print( (require 'debug').getinfo(1).source )

-- creation of table for next layer(if required)

-- No table required

-- protocol registration
my_table = DissectorTable.get('p4_lr_msg_type.msg_type')
my_table:add(0x0d,p4_expenditure_report)
