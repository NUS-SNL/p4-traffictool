--Template for addition of new protocol 'cpu_header'

--[[ Necessary changes to other files:
-- - packet.lua: if the header has a length member, adapt packetSetLength; 
-- 				 if the packet has a checksum, adapt createStack (loop at end of function) and packetCalculateChecksums
-- - proto/proto.lua: add PROTO.lua to the list so it gets loaded
--]]

local ffi = require "ffi"
local dpdkc = require "dpdkc"

require "utils"
require "proto.template"
local initHeader = initHeader


local ntoh, hton = ntoh, hton
local ntoh16, hton16 = ntoh16, hton16
local bor, band, bnot, rshift, lshift= bit.bor, bit.band, bit.bnot, bit.rshift, bit.lshift
local istype = ffi.istype
local format = string.format

function hton64(int)
	int = int or 0
	endianness = string.dump(function() end):byte(7)
	if endianness==0 then
		return int
	end
	low_int = lshift(hton(band(int,0xFFFFFFFFULL)),32)
	high_int = rshift(hton(band(int,0xFFFFFFFF00000000ULL)),32)
	endianness = string.dump(function() end):byte(7)
	return (high_int+low_int)
end


local ntoh64, hton64 = ntoh64, hton64

----- 24 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_24{
		uint32_t intequiv;
	};
]]

local bitfield24 = {}
bitfield24.__index = bitfield24
local bitfield24Type = ffi.typeof("union bitfield_24")

function bitfield24:get()
	return hton(self.intequiv)
end

function bitfield24:set(addr)
	addr = addr or 0
	self.intequiv = hton(tonumber(band(addr,0xFFFFFFFFULL)))

end

----- 40 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_40{
		uint64_t intequiv;
	};
]]

local bitfield40 = {}
bitfield40.__index = bitfield40
local bitfield40Type = ffi.typeof("union bitfield_40")

function bitfield40:get()
	return hton64(self.intequiv)
end

function bitfield40:set(addr)
	addr = addr or 0
	self.intequiv = hton64(tonumber(band(addr,0xFFFFFFFFFFFFFFFFULL)))
end

----- 48 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_48{
		uint32_t intequiv;
	};
]]

local bitfield48 = {}
bitfield48.__index = bitfield48
local bitfield48Type = ffi.typeof("union bitfield_48")

function bitfield48:get()
	return hton64(self.intequiv)
end

function bitfield48:set(addr)
	addr = addr or 0
	self.intequiv = hton64(tonumber(band(addr,0xFFFFFFFFFFFFFFFFULL)))
end


-----------------------------------------------------
---- CPU_HEADER header and constants 
-----------------------------------------------------
local CPU_HEADER = {}

CPU_HEADER.headerFormat = [[
	uint64_t 	 preamble;
	uint8_t 	 device;
	uint8_t 	 reason;
	uint8_t 	 if_index;
]]


-- variable length fields
CPU_HEADER.headerVariableMember = nil

-- Module for CPU_HEADER_address struct
local CPU_HEADERHeader = initHeader()
CPU_HEADERHeader.__index = CPU_HEADERHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function CPU_HEADERHeader:getPREAMBLE()
	return hton64(self.preamble)
end

function CPU_HEADERHeader:getPREAMBLEstring()
	return self:getPREAMBLE()
end

function CPU_HEADERHeader:setPREAMBLE(int)
	int = int or 0
	self.preamble = hton64(int)
end


function CPU_HEADERHeader:getDEVICE()
	return (self.device)
end

function CPU_HEADERHeader:getDEVICEstring()
	return self:getDEVICE()
end

function CPU_HEADERHeader:setDEVICE(int)
	int = int or 0
	self.device = (int)
end


function CPU_HEADERHeader:getREASON()
	return (self.reason)
end

function CPU_HEADERHeader:getREASONstring()
	return self:getREASON()
end

function CPU_HEADERHeader:setREASON(int)
	int = int or 0
	self.reason = (int)
end


function CPU_HEADERHeader:getIF_INDEX()
	return (self.if_index)
end

function CPU_HEADERHeader:getIF_INDEXstring()
	return self:getIF_INDEX()
end

function CPU_HEADERHeader:setIF_INDEX(int)
	int = int or 0
	self.if_index = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function CPU_HEADERHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'CPU_HEADER'

	self:setPREAMBLE(args[pre .. 'PREAMBLE'])
	self:setDEVICE(args[pre .. 'DEVICE'])
	self:setREASON(args[pre .. 'REASON'])
	self:setIF_INDEX(args[pre .. 'IF_INDEX'])
end

-- Retrieve the values of all members
function CPU_HEADERHeader:get(pre)
	pre = pre or 'CPU_HEADER'

	local args = {}
	args[pre .. 'PREAMBLE'] = self:getPREAMBLE()
	args[pre .. 'DEVICE'] = self:getDEVICE()
	args[pre .. 'REASON'] = self:getREASON()
	args[pre .. 'IF_INDEX'] = self:getIF_INDEX()

	return args
end

function CPU_HEADERHeader:getString()
	return 'CPU_HEADER \n'
		.. 'PREAMBLE' .. self:getPREAMBLEString() .. '\n'
		.. 'DEVICE' .. self:getDEVICEString() .. '\n'
		.. 'REASON' .. self:getREASONString() .. '\n'
		.. 'IF_INDEX' .. self:getIF_INDEXString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function CPU_HEADERHeader:resolveNextHeader()
	return ethernet
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)CPU_HEADER.metatype = CPU_HEADERHeader

return CPU_HEADER