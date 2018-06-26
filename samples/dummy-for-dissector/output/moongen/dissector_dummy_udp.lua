--Template for addition of new protocol 'udp'

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
	low_int = lshift(hton(band(int,0xFFFFFFFFULL)),32)
	high_int = rshift(hton(band(int,0xFFFFFFFF00000000ULL)),32)
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
---- UDP header and constants 
-----------------------------------------------------
local UDP = {}

UDP.headerFormat = [[
	uint16_t 	 srcPort;
	uint16_t 	 dstPort;
	uint16_t 	 hdr_length;
	uint16_t 	 checksum;
]]


-- variable length fields
UDP.headerVariableMember = nil

-- Module for UDP_address struct
local UDPHeader = initHeader()
UDPHeader.__index = UDPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function UDPHeader:getSRCPORT()
	return hton16(self.srcPort)
end

function UDPHeader:getSRCPORTstring()
	return self:getSRCPORT()
end

function UDPHeader:setSRCPORT(int)
	int = int or 0
	self.srcPort = hton16(int)
end


function UDPHeader:getDSTPORT()
	return hton16(self.dstPort)
end

function UDPHeader:getDSTPORTstring()
	return self:getDSTPORT()
end

function UDPHeader:setDSTPORT(int)
	int = int or 0
	self.dstPort = hton16(int)
end


function UDPHeader:getHDR_LENGTH()
	return hton16(self.hdr_length)
end

function UDPHeader:getHDR_LENGTHstring()
	return self:getHDR_LENGTH()
end

function UDPHeader:setHDR_LENGTH(int)
	int = int or 0
	self.hdr_length = hton16(int)
end


function UDPHeader:getCHECKSUM()
	return hton16(self.checksum)
end

function UDPHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function UDPHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function UDPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'UDP'

	self:setSRCPORT(args[pre .. 'SRCPORT'])
	self:setDSTPORT(args[pre .. 'DSTPORT'])
	self:setHDR_LENGTH(args[pre .. 'HDR_LENGTH'])
	self:setCHECKSUM(args[pre .. 'CHECKSUM'])
end

-- Retrieve the values of all members
function UDPHeader:get(pre)
	pre = pre or 'UDP'

	local args = {}
	args[pre .. 'SRCPORT'] = self:getSRCPORT()
	args[pre .. 'DSTPORT'] = self:getDSTPORT()
	args[pre .. 'HDR_LENGTH'] = self:getHDR_LENGTH()
	args[pre .. 'CHECKSUM'] = self:getCHECKSUM()

	return args
end

function UDPHeader:getString()
	return 'UDP \n'
		.. 'SRCPORT' .. self:getSRCPORTString() .. '\n'
		.. 'DSTPORT' .. self:getDSTPORTString() .. '\n'
		.. 'HDR_LENGTH' .. self:getHDR_LENGTHString() .. '\n'
		.. 'CHECKSUM' .. self:getCHECKSUMString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	Q_META = 0x1e61,
	SNAPSHOT = 0x22b8,
}
function UDPHeader:resolveNextHeader()
	local key = self:getDSTPORT()
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
ffi.metatype('union bitfield_48',bitfield48)UDP.metatype = UDPHeader

return UDP