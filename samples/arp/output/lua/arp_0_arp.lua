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

-----------------------------------------------------
---- ARP header and constants 
-----------------------------------------------------
local ARP = {}

ARP.headerFormat = [[
	16 	 htype;
	16 	 ptype;
	8 	 hlen;
	8 	 plen;
	16 	 oper;
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
	return hton(self.htype)
end

function ARPHeader:getHTYPEstring()
	return self:getHTYPE()
end

function ARPHeader:setHTYPE(int)
	int = int or 0
	self.htype = hton(int)
end


function ARPHeader:getPTYPE()
	return hton(self.ptype)
end

function ARPHeader:getPTYPEstring()
	return self:getPTYPE()
end

function ARPHeader:setPTYPE(int)
	int = int or 0
	self.ptype = hton(int)
end


function ARPHeader:getHLEN()
	return hton(self.hlen)
end

function ARPHeader:getHLENstring()
	return self:getHLEN()
end

function ARPHeader:setHLEN(int)
	int = int or 0
	self.hlen = hton(int)
end


function ARPHeader:getPLEN()
	return hton(self.plen)
end

function ARPHeader:getPLENstring()
	return self:getPLEN()
end

function ARPHeader:setPLEN(int)
	int = int or 0
	self.plen = hton(int)
end


function ARPHeader:getOPER()
	return hton(self.oper)
end

function ARPHeader:getOPERstring()
	return self:getOPER()
end

function ARPHeader:setOPER(int)
	int = int or 0
	self.oper = hton(int)
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

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	arp_ipv4 = 0x000108000604,
}
function ARPHeader:resolveNextHeader()
	local key = self:getHTYPE()
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
ARP.metatype = ARPHeader

return ARP