--Template for addition of new protocol 'icmp'

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
---- icmp header and constants 
-----------------------------------------------------
local icmp = {}

icmp.headerFormat = [[
	uint8_t 	 type;
	uint8_t 	 code;
	uint16_t 	 checksum;
]]


-- variable length fields
icmp.headerVariableMember = nil

-- Module for icmp_address struct
local icmpHeader = initHeader()
icmpHeader.__index = icmpHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function icmpHeader:getTYPE()
	return (self.type)
end

function icmpHeader:getTYPEstring()
	return self:getTYPE()
end

function icmpHeader:setTYPE(int)
	int = int or 0
	self.type = (int)
end


function icmpHeader:getCODE()
	return (self.code)
end

function icmpHeader:getCODEstring()
	return self:getCODE()
end

function icmpHeader:setCODE(int)
	int = int or 0
	self.code = (int)
end


function icmpHeader:getCHECKSUM()
	return hton16(self.checksum)
end

function icmpHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function icmpHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function icmpHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'icmp'

	self:setTYPE(args[pre .. 'TYPE'])
	self:setCODE(args[pre .. 'CODE'])
	self:setCHECKSUM(args[pre .. 'CHECKSUM'])
end

-- Retrieve the values of all members
function icmpHeader:get(pre)
	pre = pre or 'icmp'

	local args = {}
	args[pre .. 'TYPE'] = self:getTYPE()
	args[pre .. 'CODE'] = self:getCODE()
	args[pre .. 'CHECKSUM'] = self:getCHECKSUM()

	return args
end

function icmpHeader:getString()
	return 'icmp \n'
		.. 'TYPE' .. self:getTYPEString() .. '\n'
		.. 'CODE' .. self:getCODEString() .. '\n'
		.. 'CHECKSUM' .. self:getCHECKSUMString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function icmpHeader:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)
icmp.metatype = icmpHeader

return icmp