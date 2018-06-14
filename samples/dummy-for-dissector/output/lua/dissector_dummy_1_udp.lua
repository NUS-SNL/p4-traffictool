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

-----------------------------------------------------
---- UDP header and constants 
-----------------------------------------------------
local UDP = {}

UDP.headerFormat = [[
	16 	 srcPort;
	16 	 dstPort;
	16 	 hdr_length;
	16 	 checksum;
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
	return hton(self.srcPort)
end

function UDPHeader:getSRCPORTstring()
	return self:getSRCPORT()
end

function UDPHeader:setSRCPORT(int)
	int = int or 0
	self.srcPort = hton(int)
end


function UDPHeader:getDSTPORT()
	return hton(self.dstPort)
end

function UDPHeader:getDSTPORTstring()
	return self:getDSTPORT()
end

function UDPHeader:setDSTPORT(int)
	int = int or 0
	self.dstPort = hton(int)
end


function UDPHeader:getHDR_LENGTH()
	return hton(self.hdr_length)
end

function UDPHeader:getHDR_LENGTHstring()
	return self:getHDR_LENGTH()
end

function UDPHeader:setHDR_LENGTH(int)
	int = int or 0
	self.hdr_length = hton(int)
end


function UDPHeader:getCHECKSUM()
	return hton(self.checksum)
end

function UDPHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function UDPHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton(int)
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

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	q_meta = 0x1e61,
	snapshot = 0x22b8,
}
function UDPHeader:resolveNextHeader()
	local key = self:getDSTPORT()
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
UDP.metatype = UDPHeader

return UDP