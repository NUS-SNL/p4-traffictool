--Template for addition of new protocol 'tmp_hdr'

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
---- TMP_HDR header and constants 
-----------------------------------------------------
local TMP_HDR = {}

TMP_HDR.headerFormat = [[
	uint8_t 	 value;
	uint8_t 	 len;
]]


-- variable length fields
TMP_HDR.headerVariableMember = nil

-- Module for TMP_HDR_address struct
local TMP_HDRHeader = initHeader()
TMP_HDRHeader.__index = TMP_HDRHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function TMP_HDRHeader:getVALUE()
	return (self.value)
end

function TMP_HDRHeader:getVALUEstring()
	return self:getVALUE()
end

function TMP_HDRHeader:setVALUE(int)
	int = int or 0
	self.value = (int)
end


function TMP_HDRHeader:getLEN()
	return (self.len)
end

function TMP_HDRHeader:getLENstring()
	return self:getLEN()
end

function TMP_HDRHeader:setLEN(int)
	int = int or 0
	self.len = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function TMP_HDRHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'TMP_HDR'

	self:setVALUE(args[pre .. 'VALUE'])
	self:setLEN(args[pre .. 'LEN'])
end

-- Retrieve the values of all members
function TMP_HDRHeader:get(pre)
	pre = pre or 'TMP_HDR'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()
	args[pre .. 'LEN'] = self:getLEN()

	return args
end

function TMP_HDRHeader:getString()
	return 'TMP_HDR \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
		.. 'LEN' .. self:getLENString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function TMP_HDRHeader:resolveNextHeader()
	return scalars
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)TMP_HDR.metatype = TMP_HDRHeader

return TMP_HDR