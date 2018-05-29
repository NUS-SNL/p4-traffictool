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

p4_proto = Proto("p4_tcp","P4_TCP Protocol")
function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4_TCP"
    local subtree = tree:add(p4_proto,buffer(),"P4_TCP Protocol Data")
    subtree:add(buffer(0,2), "srcPort (16 bits) - Hex: " .. string.format("%04X", buffer(0,2):bitfield(0, 16)))
    subtree:add(buffer(2,2), "dstPort (16 bits) - Hex: " .. string.format("%04X", buffer(2,2):bitfield(0, 16)))
    subtree:add(buffer(4,4), "seqNo (32 bits) - Hex: " .. string.format("%08X", buffer(4,4):bitfield(0, 32)))
    subtree:add(buffer(8,4), "ackNo (32 bits) - Hex: " .. string.format("%08X", buffer(8,4):bitfield(0, 32)))
    subtree:add(buffer(12,1), "dataOffset (4 bits) - Binary: " .. tobits(buffer(12,1):uint(), 8, 1, 4))
    subtree:add(buffer(12,1), "res (4 bits) - Binary: " .. tobits(buffer(12,1):uint(), 8, 5, 8))
    subtree:add(buffer(13,1), "flags (8 bits) - Hex: " .. string.format("%02X", buffer(13,1):bitfield(0, 8)))
    subtree:add(buffer(14,2), "window (16 bits) - Hex: " .. string.format("%04X", buffer(14,2):bitfield(0, 16)))
    subtree:add(buffer(16,2), "checksum (16 bits) - Hex: " .. string.format("%04X", buffer(16,2):bitfield(0, 16)))
    subtree:add(buffer(18,2), "urgentPtr (16 bits) - Hex: " .. string.format("%04X", buffer(18,2):bitfield(0, 16)))
end

my_table = DissectorTable.get("ip.proto")
my_table:add(6, p4_proto)
