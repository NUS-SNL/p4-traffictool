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
---- ICMP header and constants 
-----------------------------------------------------
local ICMP = {}

ICMP.headerFormat = [[
	uint8_t 	 type;
	uint8_t 	 code;
	uint16_t 	 checksum;
]]


-- variable length fields
ICMP.headerVariableMember = nil

-- Module for ICMP_address struct
local ICMPHeader = initHeader()
ICMPHeader.__index = ICMPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ICMPHeader:getTYPE()
	return (self.type)
end

function ICMPHeader:getTYPEstring()
	return self:getTYPE()
end

function ICMPHeader:setTYPE(int)
	int = int or 0
	self.type = (int)
end


function ICMPHeader:getCODE()
	return (self.code)
end

function ICMPHeader:getCODEstring()
	return self:getCODE()
end

function ICMPHeader:setCODE(int)
	int = int or 0
	self.code = (int)
end


function ICMPHeader:getCHECKSUM()
	return hton16(self.checksum)
end

function ICMPHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function ICMPHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ICMPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'ICMP'

	self:setTYPE(args[pre .. 'TYPE'])
	self:setCODE(args[pre .. 'CODE'])
	self:setCHECKSUM(args[pre .. 'CHECKSUM'])
end

-- Retrieve the values of all members
function ICMPHeader:get(pre)
	pre = pre or 'ICMP'

	local args = {}
	args[pre .. 'TYPE'] = self:getTYPE()
	args[pre .. 'CODE'] = self:getCODE()
	args[pre .. 'CHECKSUM'] = self:getCHECKSUM()

	return args
end

function ICMPHeader:getString()
	return 'ICMP \n'
		.. 'TYPE' .. self:getTYPEString() .. '\n'
		.. 'CODE' .. self:getCODEString() .. '\n'
		.. 'CHECKSUM' .. self:getCHECKSUMString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function ICMPHeader:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)ICMP.metatype = ICMPHeader

return ICMP