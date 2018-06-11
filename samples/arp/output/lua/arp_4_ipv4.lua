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

-----------------------------------------------------
---- IPV4 header and constants 
-----------------------------------------------------
local IPV4 = {}

IPV4.headerFormat = [[
	4 	 version;
	4 	 ihl;
	8 	 diffserv;
	16 	 totalLen;
	16 	 identification;
	3 	 flags;
	13 	 fragOffset;
	8 	 ttl;
	8 	 protocol;
	16 	 hdrChecksum;
	32 	 srcAddr;
	32 	 dstAddr;
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
	return hton(self.version)
end

function IPV4Header:getVERSIONstring()
	return self:getVERSION()
end

function IPV4Header:setVERSION(int)
	int = int or 0
	self.version = hton(int)
end


function IPV4Header:getIHL()
	return hton(self.ihl)
end

function IPV4Header:getIHLstring()
	return self:getIHL()
end

function IPV4Header:setIHL(int)
	int = int or 0
	self.ihl = hton(int)
end


function IPV4Header:getDIFFSERV()
	return hton(self.diffserv)
end

function IPV4Header:getDIFFSERVstring()
	return self:getDIFFSERV()
end

function IPV4Header:setDIFFSERV(int)
	int = int or 0
	self.diffserv = hton(int)
end


function IPV4Header:getTOTALLEN()
	return hton(self.totalLen)
end

function IPV4Header:getTOTALLENstring()
	return self:getTOTALLEN()
end

function IPV4Header:setTOTALLEN(int)
	int = int or 0
	self.totalLen = hton(int)
end


function IPV4Header:getIDENTIFICATION()
	return hton(self.identification)
end

function IPV4Header:getIDENTIFICATIONstring()
	return self:getIDENTIFICATION()
end

function IPV4Header:setIDENTIFICATION(int)
	int = int or 0
	self.identification = hton(int)
end


function IPV4Header:getFLAGS()
	return hton(self.flags)
end

function IPV4Header:getFLAGSstring()
	return self:getFLAGS()
end

function IPV4Header:setFLAGS(int)
	int = int or 0
	self.flags = hton(int)
end


function IPV4Header:getFRAGOFFSET()
	return hton(self.fragOffset)
end

function IPV4Header:getFRAGOFFSETstring()
	return self:getFRAGOFFSET()
end

function IPV4Header:setFRAGOFFSET(int)
	int = int or 0
	self.fragOffset = hton(int)
end


function IPV4Header:getTTL()
	return hton(self.ttl)
end

function IPV4Header:getTTLstring()
	return self:getTTL()
end

function IPV4Header:setTTL(int)
	int = int or 0
	self.ttl = hton(int)
end


function IPV4Header:getPROTOCOL()
	return hton(self.protocol)
end

function IPV4Header:getPROTOCOLstring()
	return self:getPROTOCOL()
end

function IPV4Header:setPROTOCOL(int)
	int = int or 0
	self.protocol = hton(int)
end


function IPV4Header:getHDRCHECKSUM()
	return hton(self.hdrChecksum)
end

function IPV4Header:getHDRCHECKSUMstring()
	return self:getHDRCHECKSUM()
end

function IPV4Header:setHDRCHECKSUM(int)
	int = int or 0
	self.hdrChecksum = hton(int)
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

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	icmp = 0x01,
}
function IPV4Header:resolveNextHeader()
	local key = self:getPROTOCOL()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4.metatype = IPV4Header

return IPV4