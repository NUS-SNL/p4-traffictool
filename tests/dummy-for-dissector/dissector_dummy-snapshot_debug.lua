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

p4_proto = Proto("p4_snapshot_debug","P4_SNAPSHOT_DEBUG Protocol")
function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4_SNAPSHOT_DEBUG"
    local subtree = tree:add(p4_proto,buffer(),"P4_SNAPSHOT_DEBUG Protocol Data")
    subtree:add(buffer(0,2), "ingress_global_tstamp_hi_16 (16 bits) - Hex: " .. string.format("%04X", buffer(0,2):bitfield(0, 16)))
    subtree:add(buffer(2,4), "ingress_global_tstamp_lo_32 (32 bits) - Hex: " .. string.format("%08X", buffer(2,4):bitfield(0, 32)))
    subtree:add(buffer(6,4), "egress_global_tstamp_lo_32 (32 bits) - Hex: " .. string.format("%08X", buffer(6,4):bitfield(0, 32)))
    subtree:add(buffer(10,4), "enq_qdepth (32 bits) - Hex: " .. string.format("%08X", buffer(10,4):bitfield(0, 32)))
    subtree:add(buffer(14,4), "deq_qdepth (32 bits) - Hex: " .. string.format("%08X", buffer(14,4):bitfield(0, 32)))
    subtree:add(buffer(18,2), "_pad0 (16 bits) - Hex: " .. string.format("%04X", buffer(18,2):bitfield(0, 16)))
    subtree:add(buffer(20,6), "orig_egress_global_tstamp (48 bits) - Hex: " .. string.format("%012X", buffer(20,6):bitfield(0, 48)))
    subtree:add(buffer(26,2), "_pad1 (16 bits) - Hex: " .. string.format("%04X", buffer(26,2):bitfield(0, 16)))
    subtree:add(buffer(28,6), "new_egress_global_tstamp (48 bits) - Hex: " .. string.format("%012X", buffer(28,6):bitfield(0, 48)))
    subtree:add(buffer(34,4), "new_enq_tstamp (32 bits) - Hex: " .. string.format("%08X", buffer(34,4):bitfield(0, 32)))
end


print( (require 'debug').getinfo(1).source )
my_table = DissectorTable.get('dstport')
my_table:add(8888, p4_proto)
