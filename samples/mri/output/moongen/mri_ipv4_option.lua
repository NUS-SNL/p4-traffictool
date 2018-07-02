--Template for addition of new protocol 'ipv4_option'

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
---- IPV4_OPTION header and constants 
-----------------------------------------------------
local IPV4_OPTION = {}

IPV4_OPTION.headerFormat = [[
	uint8_t 	 copyFlag;
	uint8_t 	 optClass;
	uint8_t 	 option;
	uint8_t 	 optionLength;
]]


-- variable length fields
IPV4_OPTION.headerVariableMember = nil

-- Module for IPV4_OPTION_address struct
local IPV4_OPTIONHeader = initHeader()
IPV4_OPTIONHeader.__index = IPV4_OPTIONHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTIONHeader:getCOPYFLAG()
	return (self.copyFlag)
end

function IPV4_OPTIONHeader:getCOPYFLAGstring()
	return self:getCOPYFLAG()
end

function IPV4_OPTIONHeader:setCOPYFLAG(int)
	int = int or 0
	self.copyFlag = (int)
end


function IPV4_OPTIONHeader:getOPTCLASS()
	return (self.optClass)
end

function IPV4_OPTIONHeader:getOPTCLASSstring()
	return self:getOPTCLASS()
end

function IPV4_OPTIONHeader:setOPTCLASS(int)
	int = int or 0
	self.optClass = (int)
end


function IPV4_OPTIONHeader:getOPTION()
	return (self.option)
end

function IPV4_OPTIONHeader:getOPTIONstring()
	return self:getOPTION()
end

function IPV4_OPTIONHeader:setOPTION(int)
	int = int or 0
	self.option = (int)
end


function IPV4_OPTIONHeader:getOPTIONLENGTH()
	return (self.optionLength)
end

function IPV4_OPTIONHeader:getOPTIONLENGTHstring()
	return self:getOPTIONLENGTH()
end

function IPV4_OPTIONHeader:setOPTIONLENGTH(int)
	int = int or 0
	self.optionLength = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTIONHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION'

	self:setCOPYFLAG(args[pre .. 'COPYFLAG'])
	self:setOPTCLASS(args[pre .. 'OPTCLASS'])
	self:setOPTION(args[pre .. 'OPTION'])
	self:setOPTIONLENGTH(args[pre .. 'OPTIONLENGTH'])
end

-- Retrieve the values of all members
function IPV4_OPTIONHeader:get(pre)
	pre = pre or 'IPV4_OPTION'

	local args = {}
	args[pre .. 'COPYFLAG'] = self:getCOPYFLAG()
	args[pre .. 'OPTCLASS'] = self:getOPTCLASS()
	args[pre .. 'OPTION'] = self:getOPTION()
	args[pre .. 'OPTIONLENGTH'] = self:getOPTIONLENGTH()

	return args
end

function IPV4_OPTIONHeader:getString()
	return 'IPV4_OPTION \n'
		.. 'COPYFLAG' .. self:getCOPYFLAGString() .. '\n'
		.. 'OPTCLASS' .. self:getOPTCLASSString() .. '\n'
		.. 'OPTION' .. self:getOPTIONString() .. '\n'
		.. 'OPTIONLENGTH' .. self:getOPTIONLENGTHString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	MRI = 0x1f,
}
function IPV4_OPTIONHeader:resolveNextHeader()
	local key = self:getOPTION()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)IPV4_OPTION.metatype = IPV4_OPTIONHeader

return IPV4_OPTION