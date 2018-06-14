--Template for addition of new protocol 'ipv4_base'

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
---- IPV4_BASE header and constants 
-----------------------------------------------------
local IPV4_BASE = {}

IPV4_BASE.headerFormat = [[
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
IPV4_BASE.headerVariableMember = nil

-- Module for IPV4_BASE_address struct
local IPV4_BASEHeader = initHeader()
IPV4_BASEHeader.__index = IPV4_BASEHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_BASEHeader:getVERSION()
	return hton(self.version)
end

function IPV4_BASEHeader:getVERSIONstring()
	return self:getVERSION()
end

function IPV4_BASEHeader:setVERSION(int)
	int = int or 0
	self.version = hton(int)
end


function IPV4_BASEHeader:getIHL()
	return hton(self.ihl)
end

function IPV4_BASEHeader:getIHLstring()
	return self:getIHL()
end

function IPV4_BASEHeader:setIHL(int)
	int = int or 0
	self.ihl = hton(int)
end


function IPV4_BASEHeader:getDIFFSERV()
	return hton(self.diffserv)
end

function IPV4_BASEHeader:getDIFFSERVstring()
	return self:getDIFFSERV()
end

function IPV4_BASEHeader:setDIFFSERV(int)
	int = int or 0
	self.diffserv = hton(int)
end


function IPV4_BASEHeader:getTOTALLEN()
	return hton(self.totalLen)
end

function IPV4_BASEHeader:getTOTALLENstring()
	return self:getTOTALLEN()
end

function IPV4_BASEHeader:setTOTALLEN(int)
	int = int or 0
	self.totalLen = hton(int)
end


function IPV4_BASEHeader:getIDENTIFICATION()
	return hton(self.identification)
end

function IPV4_BASEHeader:getIDENTIFICATIONstring()
	return self:getIDENTIFICATION()
end

function IPV4_BASEHeader:setIDENTIFICATION(int)
	int = int or 0
	self.identification = hton(int)
end


function IPV4_BASEHeader:getFLAGS()
	return hton(self.flags)
end

function IPV4_BASEHeader:getFLAGSstring()
	return self:getFLAGS()
end

function IPV4_BASEHeader:setFLAGS(int)
	int = int or 0
	self.flags = hton(int)
end


function IPV4_BASEHeader:getFRAGOFFSET()
	return hton(self.fragOffset)
end

function IPV4_BASEHeader:getFRAGOFFSETstring()
	return self:getFRAGOFFSET()
end

function IPV4_BASEHeader:setFRAGOFFSET(int)
	int = int or 0
	self.fragOffset = hton(int)
end


function IPV4_BASEHeader:getTTL()
	return hton(self.ttl)
end

function IPV4_BASEHeader:getTTLstring()
	return self:getTTL()
end

function IPV4_BASEHeader:setTTL(int)
	int = int or 0
	self.ttl = hton(int)
end


function IPV4_BASEHeader:getPROTOCOL()
	return hton(self.protocol)
end

function IPV4_BASEHeader:getPROTOCOLstring()
	return self:getPROTOCOL()
end

function IPV4_BASEHeader:setPROTOCOL(int)
	int = int or 0
	self.protocol = hton(int)
end


function IPV4_BASEHeader:getHDRCHECKSUM()
	return hton(self.hdrChecksum)
end

function IPV4_BASEHeader:getHDRCHECKSUMstring()
	return self:getHDRCHECKSUM()
end

function IPV4_BASEHeader:setHDRCHECKSUM(int)
	int = int or 0
	self.hdrChecksum = hton(int)
end


function IPV4_BASEHeader:getSRCADDR()
	return hton(self.srcAddr)
end

function IPV4_BASEHeader:getSRCADDRstring()
	return self:getSRCADDR()
end

function IPV4_BASEHeader:setSRCADDR(int)
	int = int or 0
	self.srcAddr = hton(int)
end


function IPV4_BASEHeader:getDSTADDR()
	return hton(self.dstAddr)
end

function IPV4_BASEHeader:getDSTADDRstring()
	return self:getDSTADDR()
end

function IPV4_BASEHeader:setDSTADDR(int)
	int = int or 0
	self.dstAddr = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_BASEHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_BASE'

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
function IPV4_BASEHeader:get(pre)
	pre = pre or 'IPV4_BASE'

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

function IPV4_BASEHeader:getString()
	return 'IPV4_BASE \n'
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
	parse_ipv4_options = None,
}
function IPV4_BASEHeader:resolveNextHeader()
	local key = self:getIHL()
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
IPV4_BASE.metatype = IPV4_BASEHeader

return IPV4_BASE