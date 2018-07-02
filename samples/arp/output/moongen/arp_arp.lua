--Template for addition of new protocol 'arp'

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
---- ARP header and constants 
-----------------------------------------------------
local ARP = {}

ARP.headerFormat = [[
	uint16_t 	 htype;
	uint16_t 	 ptype;
	uint8_t 	 hlen;
	uint8_t 	 plen;
	uint16_t 	 oper;
]]


-- variable length fields
ARP.headerVariableMember = nil

-- Module for ARP_address struct
local ARPHeader = initHeader()
ARPHeader.__index = ARPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ARPHeader:getHTYPE()
	return hton16(self.htype)
end

function ARPHeader:getHTYPEstring()
	return self:getHTYPE()
end

function ARPHeader:setHTYPE(int)
	int = int or 0
	self.htype = hton16(int)
end


function ARPHeader:getPTYPE()
	return hton16(self.ptype)
end

function ARPHeader:getPTYPEstring()
	return self:getPTYPE()
end

function ARPHeader:setPTYPE(int)
	int = int or 0
	self.ptype = hton16(int)
end


function ARPHeader:getHLEN()
	return (self.hlen)
end

function ARPHeader:getHLENstring()
	return self:getHLEN()
end

function ARPHeader:setHLEN(int)
	int = int or 0
	self.hlen = (int)
end


function ARPHeader:getPLEN()
	return (self.plen)
end

function ARPHeader:getPLENstring()
	return self:getPLEN()
end

function ARPHeader:setPLEN(int)
	int = int or 0
	self.plen = (int)
end


function ARPHeader:getOPER()
	return hton16(self.oper)
end

function ARPHeader:getOPERstring()
	return self:getOPER()
end

function ARPHeader:setOPER(int)
	int = int or 0
	self.oper = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ARPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'ARP'

	self:setHTYPE(args[pre .. 'HTYPE'])
	self:setPTYPE(args[pre .. 'PTYPE'])
	self:setHLEN(args[pre .. 'HLEN'])
	self:setPLEN(args[pre .. 'PLEN'])
	self:setOPER(args[pre .. 'OPER'])
end

-- Retrieve the values of all members
function ARPHeader:get(pre)
	pre = pre or 'ARP'

	local args = {}
	args[pre .. 'HTYPE'] = self:getHTYPE()
	args[pre .. 'PTYPE'] = self:getPTYPE()
	args[pre .. 'HLEN'] = self:getHLEN()
	args[pre .. 'PLEN'] = self:getPLEN()
	args[pre .. 'OPER'] = self:getOPER()

	return args
end

function ARPHeader:getString()
	return 'ARP \n'
		.. 'HTYPE' .. self:getHTYPEString() .. '\n'
		.. 'PTYPE' .. self:getPTYPEString() .. '\n'
		.. 'HLEN' .. self:getHLENString() .. '\n'
		.. 'PLEN' .. self:getPLENString() .. '\n'
		.. 'OPER' .. self:getOPERString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	ARP_IPV4 = 0x000108000604,
}
function ARPHeader:resolveNextHeader()
	local key = self:getHTYPE()
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
ffi.metatype('union bitfield_48',bitfield48)ARP.metatype = ARPHeader

return ARP