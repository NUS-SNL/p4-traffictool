--Template for addition of new protocol 'icmp'

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
---- ICMP header and constants 
-----------------------------------------------------
local ICMP = {}

ICMP.headerFormat = [[
	8 	 type;
	8 	 code;
	16 	 checksum;
]]


-- variable length fields
ICMP.headerVariableMember = nil

-- Module for ICMP_address struct
local ICMPHeader = initHeader()
ICMPHeader.__index = ICMPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ICMPHeader:getTYPE()
	return hton(self.type)
end

function ICMPHeader:getTYPEstring()
	return self:getTYPE()
end

function ICMPHeader:setTYPE(int)
	int = int or 0
	self.type = hton(int)
end


function ICMPHeader:getCODE()
	return hton(self.code)
end

function ICMPHeader:getCODEstring()
	return self:getCODE()
end

function ICMPHeader:setCODE(int)
	int = int or 0
	self.code = hton(int)
end


function ICMPHeader:getCHECKSUM()
	return hton(self.checksum)
end

function ICMPHeader:getCHECKSUMstring()
	return self:getCHECKSUM()
end

function ICMPHeader:setCHECKSUM(int)
	int = int or 0
	self.checksum = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ICMPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'ICMP'

	self:setTYPE(args[pre .. 'TYPE'])
	self:setCODE(args[pre .. 'CODE'])
	self:setCHECKSUM(args[pre .. 'CHECKSUM'])
end

-- Retrieve the values of all members
function ICMPHeader:get(pre)
	pre = pre or 'ICMP'

	local args = {}
	args[pre .. 'TYPE'] = self:getTYPE()
	args[pre .. 'CODE'] = self:getCODE()
	args[pre .. 'CHECKSUM'] = self:getCHECKSUM()

	return args
end

function ICMPHeader:getString()
	return 'ICMP \n'
		.. 'TYPE' .. self:getTYPEString() .. '\n'
		.. 'CODE' .. self:getCODEString() .. '\n'
		.. 'CHECKSUM' .. self:getCHECKSUMString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function ICMPHeader:resolveNextHeader()
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ICMP.metatype = ICMPHeader

return ICMP