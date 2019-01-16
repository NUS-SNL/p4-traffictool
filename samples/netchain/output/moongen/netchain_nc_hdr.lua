--Template for addition of new protocol 'nc_hdr'

--[[ Necessary changes to other files:
-- - packet.lua: if the header has a length member, adapt packetSetLength; 
-- 				 if the packet has a checksum, adapt createStack (loop at end of function) and packetCalculateChecksums
-- - proto/proto.lua: add PROTO.lua to the list so it gets loaded
--]]

local ffi = require "ffi"
local dpdkc = require "dpdkc"

require "bitfields_def"
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


-----------------------------------------------------
---- netchain_nc_hdr header and constants 
-----------------------------------------------------
local netchain_nc_hdr = {}

netchain_nc_hdr.headerFormat = [[
	uint8_t 	 op;
	uint8_t 	 sc;
	uint16_t 	 seq;
	uint64_t 	 key;
	uint64_t 	 value;
	uint16_t 	 vgroup;
]]


-- variable length fields
netchain_nc_hdr.headerVariableMember = nil

-- Module for netchain_nc_hdr_address struct
local netchain_nc_hdrHeader = initHeader()
netchain_nc_hdrHeader.__index = netchain_nc_hdrHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netchain_nc_hdrHeader:getOP()
	return (self.op)
end

function netchain_nc_hdrHeader:getOPstring()
	return self:getOP()
end

function netchain_nc_hdrHeader:setOP(int)
	int = int or 0
	self.op = (int)
end


function netchain_nc_hdrHeader:getSC()
	return (self.sc)
end

function netchain_nc_hdrHeader:getSCstring()
	return self:getSC()
end

function netchain_nc_hdrHeader:setSC(int)
	int = int or 0
	self.sc = (int)
end


function netchain_nc_hdrHeader:getSEQ()
	return hton16(self.seq)
end

function netchain_nc_hdrHeader:getSEQstring()
	return self:getSEQ()
end

function netchain_nc_hdrHeader:setSEQ(int)
	int = int or 0
	self.seq = hton16(int)
end


function netchain_nc_hdrHeader:getKEY()
	return hton64(self.key)
end

function netchain_nc_hdrHeader:getKEYstring()
	return self:getKEY()
end

function netchain_nc_hdrHeader:setKEY(int)
	int = int or 0
	self.key = hton64(int)
end


function netchain_nc_hdrHeader:getVALUE()
	return hton64(self.value)
end

function netchain_nc_hdrHeader:getVALUEstring()
	return self:getVALUE()
end

function netchain_nc_hdrHeader:setVALUE(int)
	int = int or 0
	self.value = hton64(int)
end


function netchain_nc_hdrHeader:getVGROUP()
	return hton16(self.vgroup)
end

function netchain_nc_hdrHeader:getVGROUPstring()
	return self:getVGROUP()
end

function netchain_nc_hdrHeader:setVGROUP(int)
	int = int or 0
	self.vgroup = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netchain_nc_hdrHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'netchain_nc_hdr'

	self:setOP(args[pre .. 'OP'])
	self:setSC(args[pre .. 'SC'])
	self:setSEQ(args[pre .. 'SEQ'])
	self:setKEY(args[pre .. 'KEY'])
	self:setVALUE(args[pre .. 'VALUE'])
	self:setVGROUP(args[pre .. 'VGROUP'])
end

-- Retrieve the values of all members
function netchain_nc_hdrHeader:get(pre)
	pre = pre or 'netchain_nc_hdr'

	local args = {}
	args[pre .. 'OP'] = self:getOP()
	args[pre .. 'SC'] = self:getSC()
	args[pre .. 'SEQ'] = self:getSEQ()
	args[pre .. 'KEY'] = self:getKEY()
	args[pre .. 'VALUE'] = self:getVALUE()
	args[pre .. 'VGROUP'] = self:getVGROUP()

	return args
end

function netchain_nc_hdrHeader:getString()
	return 'netchain_nc_hdr \n'
		.. 'OP' .. self:getOPString() .. '\n'
		.. 'SC' .. self:getSCString() .. '\n'
		.. 'SEQ' .. self:getSEQString() .. '\n'
		.. 'KEY' .. self:getKEYString() .. '\n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
		.. 'VGROUP' .. self:getVGROUPString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function netchain_nc_hdrHeader:resolveNextHeader()
	return nil
end

function netchain_nc_hdrHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netchain_nc_hdr.metatype = netchain_nc_hdrHeader

return netchain_nc_hdr