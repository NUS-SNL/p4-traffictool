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

p4_proto = Proto("p4_ipv4","P4_IPV4 Protocol")
function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4_IPV4"
    local subtree = tree:add(p4_proto,buffer(),"P4_IPV4 Protocol Data")
    subtree:add(buffer(0,1), "version (4 bits) - Binary: " .. tobits(buffer(0,1):uint(), 8, 1, 4))
    subtree:add(buffer(0,1), "ihl (4 bits) - Binary: " .. tobits(buffer(0,1):uint(), 8, 5, 8))
    subtree:add(buffer(1,1), "diffserv (8 bits) - Hex: " .. string.format("%02X", buffer(1,1):bitfield(0, 8)))
    subtree:add(buffer(2,2), "totalLen (16 bits) - Hex: " .. string.format("%04X", buffer(2,2):bitfield(0, 16)))
    subtree:add(buffer(4,2), "identification (16 bits) - Hex: " .. string.format("%04X", buffer(4,2):bitfield(0, 16)))
    subtree:add(buffer(6,1), "flags (3 bits) - Binary: " .. tobits(buffer(6,1):uint(), 8, 1, 3))
    subtree:add(buffer(6,2), "fragOffset (13 bits) - Hex: " .. string.format("%04X", buffer(6,2):bitfield(3, 13)))
    subtree:add(buffer(8,1), "ttl (8 bits) - Hex: " .. string.format("%02X", buffer(8,1):bitfield(0, 8)))
    subtree:add(buffer(9,1), "protocol (8 bits) - Hex: " .. string.format("%02X", buffer(9,1):bitfield(0, 8)))
    subtree:add(buffer(10,2), "hdrChecksum (16 bits) - Hex: " .. string.format("%04X", buffer(10,2):bitfield(0, 16)))
    subtree:add(buffer(12,4), "srcAddr (32 bits) - Hex: " .. string.format("%08X", buffer(12,4):bitfield(0, 32)))
    subtree:add(buffer(16,4), "dstAddr (32 bits) - Hex: " .. string.format("%08X", buffer(16,4):bitfield(0, 32)))
end

my_table = DissectorTable.get("ethertype")
my_table:add(2048, p4_proto)
