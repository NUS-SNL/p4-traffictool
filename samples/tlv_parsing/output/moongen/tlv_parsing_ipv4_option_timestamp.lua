--Template for addition of new protocol 'ipv4_option_timestamp'

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
---- IPV4_OPTION_TIMESTAMP header and constants 
-----------------------------------------------------
local IPV4_OPTION_TIMESTAMP = {}

IPV4_OPTION_TIMESTAMP.headerFormat = [[
	uint8_t 	 value;
	uint8_t 	 len;
	-- fill blank here * 	 data;
]]


-- variable length fields
IPV4_OPTION_TIMESTAMP.headerVariableMember = nil

-- Module for IPV4_OPTION_TIMESTAMP_address struct
local IPV4_OPTION_TIMESTAMPHeader = initHeader()
IPV4_OPTION_TIMESTAMPHeader.__index = IPV4_OPTION_TIMESTAMPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTION_TIMESTAMPHeader:getVALUE()
	return (self.value)
end

function IPV4_OPTION_TIMESTAMPHeader:getVALUEstring()
	return self:getVALUE()
end

function IPV4_OPTION_TIMESTAMPHeader:setVALUE(int)
	int = int or 0
	self.value = (int)
end


function IPV4_OPTION_TIMESTAMPHeader:getLEN()
	return (self.len)
end

function IPV4_OPTION_TIMESTAMPHeader:getLENstring()
	return self:getLEN()
end

function IPV4_OPTION_TIMESTAMPHeader:setLEN(int)
	int = int or 0
	self.len = (int)
end


function IPV4_OPTION_TIMESTAMPHeader:getDATA()
	return (self.data:get())
end

function IPV4_OPTION_TIMESTAMPHeader:getDATAstring()
	return self:getDATA()
end

function IPV4_OPTION_TIMESTAMPHeader:setDATA(int)
	int = int or 0
	self.data:set(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTION_TIMESTAMPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION_TIMESTAMP'

	self:setVALUE(args[pre .. 'VALUE'])
	self:setLEN(args[pre .. 'LEN'])
	self:setDATA(args[pre .. 'DATA'])
end

-- Retrieve the values of all members
function IPV4_OPTION_TIMESTAMPHeader:get(pre)
	pre = pre or 'IPV4_OPTION_TIMESTAMP'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()
	args[pre .. 'LEN'] = self:getLEN()
	args[pre .. 'DATA'] = self:getDATA()

	return args
end

function IPV4_OPTION_TIMESTAMPHeader:getString()
	return 'IPV4_OPTION_TIMESTAMP \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
		.. 'LEN' .. self:getLENString() .. '\n'
		.. 'DATA' .. self:getDATAString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function IPV4_OPTION_TIMESTAMPHeader:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)IPV4_OPTION_TIMESTAMP.metatype = IPV4_OPTION_TIMESTAMPHeader

return IPV4_OPTION_TIMESTAMP