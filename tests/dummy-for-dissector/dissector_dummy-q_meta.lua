-- Auto-generated dissector from P4 header

-- Helper functions

-- Return a slice of a table
function table_slice(input_table, first, last)
  local subtable = {}
  for i = first, last do
    subtable[#subtable + 1] = input_table[i]
  end
  return subtable
end

-- Convert a number to bits
function tobits(number, bitcount, first_bit, last_bit)
    local bit_table = {}
    for bit_index = bitcount, 1, -1 do
        remainder = math.fmod(number, 2)
        bit_table[bit_index] = remainder
        number = (number - remainder) / 2
    end
    return table.concat(table_slice(bit_table, first_bit, last_bit))
end


-- Auto generated section

p4_proto = Proto("p4_q_meta","P4_Q_META Protocol")
function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4_Q_META"
    local subtree = tree:add(p4_proto,buffer(),"P4_Q_META Protocol Data")
    subtree:add(buffer(0,2), "flow_id (16 bits) - Hex: " .. string.format("%04X", buffer(0,2):bitfield(0, 16)))
    subtree:add(buffer(2,2), "_pad0 (16 bits) - Hex: " .. string.format("%04X", buffer(2,2):bitfield(0, 16)))
    subtree:add(buffer(4,6), "ingress_global_tstamp (48 bits) - Hex: " .. string.format("%012X", buffer(4,6):bitfield(0, 48)))
    subtree:add(buffer(10,2), "_pad1 (16 bits) - Hex: " .. string.format("%04X", buffer(10,2):bitfield(0, 16)))
    subtree:add(buffer(12,6), "egress_global_tstamp (48 bits) - Hex: " .. string.format("%012X", buffer(12,6):bitfield(0, 48)))
    subtree:add(buffer(18,2), "_spare_pad_bits (15 bits) - Hex: " .. string.format("%04X", buffer(18,2):bitfield(0, 15)))
    subtree:add(buffer(19,1), "markbit (1 bits) - Binary: " .. tobits(buffer(19,1):uint(), 8, 0, 8))
    subtree:add(buffer(20,2), "_pad2 (13 bits) - Hex: " .. string.format("%04X", buffer(20,2):bitfield(0, 13)))
    subtree:add(buffer(21,3), "enq_qdepth (19 bits) - Hex: " .. string.format("%05X", buffer(21,3):bitfield(5, 19)))
    subtree:add(buffer(24,2), "_pad3 (13 bits) - Hex: " .. string.format("%04X", buffer(24,2):bitfield(0, 13)))
    subtree:add(buffer(25,3), "deq_qdepth (19 bits) - Hex: " .. string.format("%05X", buffer(25,3):bitfield(5, 19)))
end


print( (require 'debug').getinfo(1).source )
my_table = DissectorTable.get('dstport')
my_table:add(7777, p4_proto)
