--Template for addition of new protocol 'tcp'

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
---- TCP header and constants 
-----------------------------------------------------
local TCP = {}

TCP.headerFormat = [[
	16 	 srcPort;
	16 	 dstPort;
	32 	 seqNo;
	32 	 ackNo;
	4 	 dataOffset;
	4 	 res;
	8 	 flags;
	16 	 window;
	16 	 checksum;
	16 	 urgentPtr;
]]


-- variable length fields
TCP.headerVariableMember = nil

-- Module for TCP_address struct
local TCPHeader = initHeader()
TCPHeader.__index = TCPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function TCPHeader:getSRCPORT()
	return hton(self.srcPort)
end

function TCPHeader:getSRCPORTstring()
	return self:getSRCPORT()
end

function TCPHeader:setSRCPORT(int)
	int = int or 0
	self.srcPort = hton(int)
end


function TCPHeader:getDSTPORT()
	return hton(self.dstPort)
end

function TCPHeader:getDSTPORTstring()
	return self:getDSTPORT()
end

function TCPHeader:setDSTPORT(int)
	int = int or 0
	self.dstPort = hton(int)
end


function TCPHeader:getSEQNO()
	return hton(self.seqNo)
end

function TCPHeader:getSEQNOstring()
	return self:getSEQNO()
end

function TCPHeader:setSEQNO(int)
	int = int or 0
	self.seqNo = hton(int)
end


function TCPHeader:getACKNO()
	return hton(self.ackNo)
end

function TCPHeader:getACKNOstring()
	return self:getACKNO()
end

function TCPHeader:setACKNO(int)
	int = int or 0
	self.ackNo = hton(int)
end


function TCPHeader:getDATAOFFSET()
	return hton(self.dataOffset)
end

function TCPHeader:getDATAOFFSETstring()
	return self:getDATAOFFSET()
end

function TCPHeader:setDATAOFFSET(int)
	int = int or 0
	self.dataOffset = hton(int)
end


function TCPHeader:getRES()
	return hton(self.res)
end

function TCPHeader:getRESstring()
	return self:getRES()
end

function TCPHeader:setRES(int)
	int = int or 0
	self.res = hton(int)
end


function TCPHeader:getFLAGS()
	return hton(self.flags)
end

function TCPHeader:getFLAGSstring()
	return self:getFLAGS()
end

function TCPHeader:setFLAGS(int)
	int = int or 0
	self.flags = hton(int)
end


function TCPHeader:getWINDOW()
	return hton(self.window)
end

function TCPHeader:getWINDOWstring()
	return self:getWINDOW()
end

function TCPHeader:setWINDOW(int)
	int = int or 0
	self.window = hton(int)
end


function TCPHeader:getCHECKSUM()
	return hton(self.checksum)
end

function TCPHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function TCPHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton(int)
end


function TCPHeader:getURGENTPTR()
	return hton(self.urgentPtr)
end

function TCPHeader:getURGENTPTRstring()
	return self:getURGENTPTR()
end

function TCPHeader:setURGENTPTR(int)
	int = int or 0
	self.urgentPtr = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function TCPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'TCP'

	self:setSRCPORT(args[pre .. 'SRCPORT'])
	self:setDSTPORT(args[pre .. 'DSTPORT'])
	self:setSEQNO(args[pre .. 'SEQNO'])
	self:setACKNO(args[pre .. 'ACKNO'])
	self:setDATAOFFSET(args[pre .. 'DATAOFFSET'])
	self:setRES(args[pre .. 'RES'])
	self:setFLAGS(args[pre .. 'FLAGS'])
	self:setWINDOW(args[pre .. 'WINDOW'])
	self:setCHECKSUM(args[pre .. 'CHECKSUM'])
	self:setURGENTPTR(args[pre .. 'URGENTPTR'])
end

-- Retrieve the values of all members
function TCPHeader:get(pre)
	pre = pre or 'TCP'

	local args = {}
	args[pre .. 'SRCPORT'] = self:getSRCPORT()
	args[pre .. 'DSTPORT'] = self:getDSTPORT()
	args[pre .. 'SEQNO'] = self:getSEQNO()
	args[pre .. 'ACKNO'] = self:getACKNO()
	args[pre .. 'DATAOFFSET'] = self:getDATAOFFSET()
	args[pre .. 'RES'] = self:getRES()
	args[pre .. 'FLAGS'] = self:getFLAGS()
	args[pre .. 'WINDOW'] = self:getWINDOW()
	args[pre .. 'CHECKSUM'] = self:getCHECKSUM()
	args[pre .. 'URGENTPTR'] = self:getURGENTPTR()

	return args
end

function TCPHeader:getString()
	return 'TCP \n'
		.. 'SRCPORT' .. self:getSRCPORTString() .. '\n'
		.. 'DSTPORT' .. self:getDSTPORTString() .. '\n'
		.. 'SEQNO' .. self:getSEQNOString() .. '\n'
		.. 'ACKNO' .. self:getACKNOString() .. '\n'
		.. 'DATAOFFSET' .. self:getDATAOFFSETString() .. '\n'
		.. 'RES' .. self:getRESString() .. '\n'
		.. 'FLAGS' .. self:getFLAGSString() .. '\n'
		.. 'WINDOW' .. self:getWINDOWString() .. '\n'
		.. 'CHECKSUM' .. self:getCHECKSUMString() .. '\n'
		.. 'URGENTPTR' .. self:getURGENTPTRString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function TCPHeader:resolveNextHeader()
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
TCP.metatype = TCPHeader

return TCP