--Template for addition of new protocol 'hdr_meta'

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
---- basic_postcards_hdr_meta header and constants 
-----------------------------------------------------
local basic_postcards_hdr_meta = {}

basic_postcards_hdr_meta.headerFormat = [[
	union bitfield_48 	 mac_dstAddr;
	union bitfield_48 	 mac_srcAddr;
	uint32_t 	 ip_srcAddr;
	uint32_t 	 ip_dstAddr;
	uint8_t 	 ip_protocol;
]]


-- variable length fields
basic_postcards_hdr_meta.headerVariableMember = nil

-- Module for basic_postcards_hdr_meta_address struct
local basic_postcards_hdr_metaHeader = initHeader()
basic_postcards_hdr_metaHeader.__index = basic_postcards_hdr_metaHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function basic_postcards_hdr_metaHeader:getMAC_DSTADDR()
	return (self.mac_dstAddr:get())
end

function basic_postcards_hdr_metaHeader:getMAC_DSTADDRstring()
	return self:getMAC_DSTADDR()
end

function basic_postcards_hdr_metaHeader:setMAC_DSTADDR(int)
	int = int or 0
	self.mac_dstAddr:set(int)
end


function basic_postcards_hdr_metaHeader:getMAC_SRCADDR()
	return (self.mac_srcAddr:get())
end

function basic_postcards_hdr_metaHeader:getMAC_SRCADDRstring()
	return self:getMAC_SRCADDR()
end

function basic_postcards_hdr_metaHeader:setMAC_SRCADDR(int)
	int = int or 0
	self.mac_srcAddr:set(int)
end


function basic_postcards_hdr_metaHeader:getIP_SRCADDR()
	return hton(self.ip_srcAddr)
end

function basic_postcards_hdr_metaHeader:getIP_SRCADDRstring()
	return self:getIP_SRCADDR()
end

function basic_postcards_hdr_metaHeader:setIP_SRCADDR(int)
	int = int or 0
	self.ip_srcAddr = hton(int)
end


function basic_postcards_hdr_metaHeader:getIP_DSTADDR()
	return hton(self.ip_dstAddr)
end

function basic_postcards_hdr_metaHeader:getIP_DSTADDRstring()
	return self:getIP_DSTADDR()
end

function basic_postcards_hdr_metaHeader:setIP_DSTADDR(int)
	int = int or 0
	self.ip_dstAddr = hton(int)
end


function basic_postcards_hdr_metaHeader:getIP_PROTOCOL()
	return (self.ip_protocol)
end

function basic_postcards_hdr_metaHeader:getIP_PROTOCOLstring()
	return self:getIP_PROTOCOL()
end

function basic_postcards_hdr_metaHeader:setIP_PROTOCOL(int)
	int = int or 0
	self.ip_protocol = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function basic_postcards_hdr_metaHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'basic_postcards_hdr_meta'

	self:setMAC_DSTADDR(args[pre .. 'MAC_DSTADDR'])
	self:setMAC_SRCADDR(args[pre .. 'MAC_SRCADDR'])
	self:setIP_SRCADDR(args[pre .. 'IP_SRCADDR'])
	self:setIP_DSTADDR(args[pre .. 'IP_DSTADDR'])
	self:setIP_PROTOCOL(args[pre .. 'IP_PROTOCOL'])
end

-- Retrieve the values of all members
function basic_postcards_hdr_metaHeader:get(pre)
	pre = pre or 'basic_postcards_hdr_meta'

	local args = {}
	args[pre .. 'MAC_DSTADDR'] = self:getMAC_DSTADDR()
	args[pre .. 'MAC_SRCADDR'] = self:getMAC_SRCADDR()
	args[pre .. 'IP_SRCADDR'] = self:getIP_SRCADDR()
	args[pre .. 'IP_DSTADDR'] = self:getIP_DSTADDR()
	args[pre .. 'IP_PROTOCOL'] = self:getIP_PROTOCOL()

	return args
end

function basic_postcards_hdr_metaHeader:getString()
	return 'basic_postcards_hdr_meta \n'
		.. 'MAC_DSTADDR' .. self:getMAC_DSTADDRString() .. '\n'
		.. 'MAC_SRCADDR' .. self:getMAC_SRCADDRString() .. '\n'
		.. 'IP_SRCADDR' .. self:getIP_SRCADDRString() .. '\n'
		.. 'IP_DSTADDR' .. self:getIP_DSTADDRString() .. '\n'
		.. 'IP_PROTOCOL' .. self:getIP_PROTOCOLString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function basic_postcards_hdr_metaHeader:resolveNextHeader()
	return nil
end

function basic_postcards_hdr_metaHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
basic_postcards_hdr_meta.metatype = basic_postcards_hdr_metaHeader

return basic_postcards_hdr_meta