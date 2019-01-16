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
---- netcache_nc_hdr header and constants 
-----------------------------------------------------
local netcache_nc_hdr = {}

netcache_nc_hdr.headerFormat = [[
	uint8_t 	 op;
	uint64_t 	 key;
]]


-- variable length fields
netcache_nc_hdr.headerVariableMember = nil

-- Module for netcache_nc_hdr_address struct
local netcache_nc_hdrHeader = initHeader()
netcache_nc_hdrHeader.__index = netcache_nc_hdrHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netcache_nc_hdrHeader:getOP()
	return (self.op)
end

function netcache_nc_hdrHeader:getOPstring()
	return self:getOP()
end

function netcache_nc_hdrHeader:setOP(int)
	int = int or 0
	self.op = (int)
end


function netcache_nc_hdrHeader:getKEY()
	return hton64(self.key)
end

function netcache_nc_hdrHeader:getKEYstring()
	return self:getKEY()
end

function netcache_nc_hdrHeader:setKEY(int)
	int = int or 0
	self.key = hton64(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netcache_nc_hdrHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'netcache_nc_hdr'

	self:setOP(args[pre .. 'OP'])
	self:setKEY(args[pre .. 'KEY'])
end

-- Retrieve the values of all members
function netcache_nc_hdrHeader:get(pre)
	pre = pre or 'netcache_nc_hdr'

	local args = {}
	args[pre .. 'OP'] = self:getOP()
	args[pre .. 'KEY'] = self:getKEY()

	return args
end

function netcache_nc_hdrHeader:getString()
	return 'netcache_nc_hdr \n'
		.. 'OP' .. self:getOPString() .. '\n'
		.. 'KEY' .. self:getKEYString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	netcache_parse_value = 0x01,
	netcache_nc_load = 0x02,
	netcache_parse_value = 0x09,
}
function netcache_nc_hdrHeader:resolveNextHeader()
	local key = self:getOP()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function netcache_nc_hdrHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'OP'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'OP'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netcache_nc_hdr.metatype = netcache_nc_hdrHeader

return netcache_nc_hdr