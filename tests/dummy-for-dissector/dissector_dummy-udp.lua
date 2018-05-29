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

p4_proto = Proto("p4_udp","P4_UDP Protocol")
function p4_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "P4_UDP"
    local subtree = tree:add(p4_proto,buffer(),"P4_UDP Protocol Data")
    subtree:add(buffer(0,2), "srcPort (16 bits) - Hex: " .. string.format("%04X", buffer(0,2):bitfield(0, 16)))
    subtree:add(buffer(2,2), "dstPort (16 bits) - Hex: " .. string.format("%04X", buffer(2,2):bitfield(0, 16)))
    subtree:add(buffer(4,2), "hdr_length (16 bits) - Hex: " .. string.format("%04X", buffer(4,2):bitfield(0, 16)))
    subtree:add(buffer(6,2), "checksum (16 bits) - Hex: " .. string.format("%04X", buffer(6,2):bitfield(0, 16)))
end


print( (require 'debug').getinfo(1).source )
my_table = DissectorTable.get('ip.proto')
my_table:add(17, p4_proto)
