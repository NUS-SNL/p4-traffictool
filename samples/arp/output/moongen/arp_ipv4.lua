--Template for addition of new protocol 'ipv4'

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
---- IPV4 header and constants 
-----------------------------------------------------
local IPV4 = {}

IPV4.headerFormat = [[
	uint8_t 	 version;
	uint8_t 	 ihl;
	uint8_t 	 diffserv;
	uint16_t 	 totalLen;
	uint16_t 	 identification;
	uint8_t 	 flags;
	uint16_t 	 fragOffset;
	uint8_t 	 ttl;
	uint8_t 	 protocol;
	uint16_t 	 hdrChecksum;
	uint32_t 	 srcAddr;
	uint32_t 	 dstAddr;
]]


-- variable length fields
IPV4.headerVariableMember = nil

-- Module for IPV4_address struct
local IPV4Header = initHeader()
IPV4Header.__index = IPV4Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4Header:getVERSION()
	return (self.version)
end

function IPV4Header:getVERSIONstring()
	return self:getVERSION()
end

function IPV4Header:setVERSION(int)
	int = int or 0
	self.version = (int)
end


function IPV4Header:getIHL()
	return (self.ihl)
end

function IPV4Header:getIHLstring()
	return self:getIHL()
end

function IPV4Header:setIHL(int)
	int = int or 0
	self.ihl = (int)
end


function IPV4Header:getDIFFSERV()
	return (self.diffserv)
end

function IPV4Header:getDIFFSERVstring()
	return self:getDIFFSERV()
end

function IPV4Header:setDIFFSERV(int)
	int = int or 0
	self.diffserv = (int)
end


function IPV4Header:getTOTALLEN()
	return hton16(self.totalLen)
end

function IPV4Header:getTOTALLENstring()
	return self:getTOTALLEN()
end

function IPV4Header:setTOTALLEN(int)
	int = int or 0
	self.totalLen = hton16(int)
end


function IPV4Header:getIDENTIFICATION()
	return hton16(self.identification)
end

function IPV4Header:getIDENTIFICATIONstring()
	return self:getIDENTIFICATION()
end

function IPV4Header:setIDENTIFICATION(int)
	int = int or 0
	self.identification = hton16(int)
end


function IPV4Header:getFLAGS()
	return (self.flags)
end

function IPV4Header:getFLAGSstring()
	return self:getFLAGS()
end

function IPV4Header:setFLAGS(int)
	int = int or 0
	self.flags = (int)
end


function IPV4Header:getFRAGOFFSET()
	return hton16(self.fragOffset)
end

function IPV4Header:getFRAGOFFSETstring()
	return self:getFRAGOFFSET()
end

function IPV4Header:setFRAGOFFSET(int)
	int = int or 0
	self.fragOffset = hton16(int)
end


function IPV4Header:getTTL()
	return (self.ttl)
end

function IPV4Header:getTTLstring()
	return self:getTTL()
end

function IPV4Header:setTTL(int)
	int = int or 0
	self.ttl = (int)
end


function IPV4Header:getPROTOCOL()
	return (self.protocol)
end

function IPV4Header:getPROTOCOLstring()
	return self:getPROTOCOL()
end

function IPV4Header:setPROTOCOL(int)
	int = int or 0
	self.protocol = (int)
end


function IPV4Header:getHDRCHECKSUM()
	return hton16(self.hdrChecksum)
end

function IPV4Header:getHDRCHECKSUMstring()
	return self:getHDRCHECKSUM()
end

function IPV4Header:setHDRCHECKSUM(int)
	int = int or 0
	self.hdrChecksum = hton16(int)
end


function IPV4Header:getSRCADDR()
	return hton(self.srcAddr)
end

function IPV4Header:getSRCADDRstring()
	return self:getSRCADDR()
end

function IPV4Header:setSRCADDR(int)
	int = int or 0
	self.srcAddr = hton(int)
end


function IPV4Header:getDSTADDR()
	return hton(self.dstAddr)
end

function IPV4Header:getDSTADDRstring()
	return self:getDSTADDR()
end

function IPV4Header:setDSTADDR(int)
	int = int or 0
	self.dstAddr = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4Header:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4'

	self:setVERSION(args[pre .. 'VERSION'])
	self:setIHL(args[pre .. 'IHL'])
	self:setDIFFSERV(args[pre .. 'DIFFSERV'])
	self:setTOTALLEN(args[pre .. 'TOTALLEN'])
	self:setIDENTIFICATION(args[pre .. 'IDENTIFICATION'])
	self:setFLAGS(args[pre .. 'FLAGS'])
	self:setFRAGOFFSET(args[pre .. 'FRAGOFFSET'])
	self:setTTL(args[pre .. 'TTL'])
	self:setPROTOCOL(args[pre .. 'PROTOCOL'])
	self:setHDRCHECKSUM(args[pre .. 'HDRCHECKSUM'])
	self:setSRCADDR(args[pre .. 'SRCADDR'])
	self:setDSTADDR(args[pre .. 'DSTADDR'])
end

-- Retrieve the values of all members
function IPV4Header:get(pre)
	pre = pre or 'IPV4'

	local args = {}
	args[pre .. 'VERSION'] = self:getVERSION()
	args[pre .. 'IHL'] = self:getIHL()
	args[pre .. 'DIFFSERV'] = self:getDIFFSERV()
	args[pre .. 'TOTALLEN'] = self:getTOTALLEN()
	args[pre .. 'IDENTIFICATION'] = self:getIDENTIFICATION()
	args[pre .. 'FLAGS'] = self:getFLAGS()
	args[pre .. 'FRAGOFFSET'] = self:getFRAGOFFSET()
	args[pre .. 'TTL'] = self:getTTL()
	args[pre .. 'PROTOCOL'] = self:getPROTOCOL()
	args[pre .. 'HDRCHECKSUM'] = self:getHDRCHECKSUM()
	args[pre .. 'SRCADDR'] = self:getSRCADDR()
	args[pre .. 'DSTADDR'] = self:getDSTADDR()

	return args
end

function IPV4Header:getString()
	return 'IPV4 \n'
		.. 'VERSION' .. self:getVERSIONString() .. '\n'
		.. 'IHL' .. self:getIHLString() .. '\n'
		.. 'DIFFSERV' .. self:getDIFFSERVString() .. '\n'
		.. 'TOTALLEN' .. self:getTOTALLENString() .. '\n'
		.. 'IDENTIFICATION' .. self:getIDENTIFICATIONString() .. '\n'
		.. 'FLAGS' .. self:getFLAGSString() .. '\n'
		.. 'FRAGOFFSET' .. self:getFRAGOFFSETString() .. '\n'
		.. 'TTL' .. self:getTTLString() .. '\n'
		.. 'PROTOCOL' .. self:getPROTOCOLString() .. '\n'
		.. 'HDRCHECKSUM' .. self:getHDRCHECKSUMString() .. '\n'
		.. 'SRCADDR' .. self:getSRCADDRString() .. '\n'
		.. 'DSTADDR' .. self:getDSTADDRString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	ICMP = 0x01,
}
function IPV4Header:resolveNextHeader()
	local key = self:getPROTOCOL()
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
ffi.metatype('union bitfield_48',bitfield48)IPV4.metatype = IPV4Header

return IPV4