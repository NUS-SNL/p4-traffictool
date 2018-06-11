--Template for addition of new protocol 'ethernet'

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
---- ETHERNET header and constants 
-----------------------------------------------------
local ETHERNET = {}

ETHERNET.headerFormat = [[
	48 	 dstAddr;
	48 	 srcAddr;
	16 	 etherType;
]]


-- variable length fields
ETHERNET.headerVariableMember = nil

-- Module for ETHERNET_address struct
local ETHERNETHeader = initHeader()
ETHERNETHeader.__index = ETHERNETHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ETHERNETHeader:getDSTADDR()
	return hton(self.dstAddr)
end

function ETHERNETHeader:getDSTADDRstring()
	return self:getDSTADDR()
end

function ETHERNETHeader:setDSTADDR(int)
	int = int or 0
	self.dstAddr = hton(int)
end


function ETHERNETHeader:getSRCADDR()
	return hton(self.srcAddr)
end

function ETHERNETHeader:getSRCADDRstring()
	return self:getSRCADDR()
end

function ETHERNETHeader:setSRCADDR(int)
	int = int or 0
	self.srcAddr = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ETHERNETHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'ETHERNET'

	self:setDSTADDR(args[pre .. 'DSTADDR'])
	self:setSRCADDR(args[pre .. 'SRCADDR'])
	self:setETHERTYPE(args[pre .. 'ETHERTYPE'])
end

-- Retrieve the values of all members
function ETHERNETHeader:get(pre)
	pre = pre or 'ETHERNET'

	local args = {}
	args[pre .. 'DSTADDR'] = self:getDSTADDR()
	args[pre .. 'SRCADDR'] = self:getSRCADDR()
	args[pre .. 'ETHERTYPE'] = self:getETHERTYPE()

	return args
end

function ETHERNETHeader:getString()
	return 'ETHERNET \n'
		.. 'DSTADDR' .. self:getDSTADDRString() .. '\n'
		.. 'SRCADDR' .. self:getSRCADDRString() .. '\n'
		.. 'ETHERTYPE' .. self:getETHERTYPEString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	ipv4_base = 0x0800,
}
function ETHERNETHeader:resolveNextHeader()
	local key = self:getETHERTYPE()
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
ETHERNET.metatype = ETHERNETHeader

return ETHERNET