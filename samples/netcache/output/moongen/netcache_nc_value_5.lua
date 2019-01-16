--Template for addition of new protocol 'nc_value_5'

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
---- netcache_nc_value_5 header and constants 
-----------------------------------------------------
local netcache_nc_value_5 = {}

netcache_nc_value_5.headerFormat = [[
	uint32_t 	 value_5_1;
	uint32_t 	 value_5_2;
	uint32_t 	 value_5_3;
	uint32_t 	 value_5_4;
]]


-- variable length fields
netcache_nc_value_5.headerVariableMember = nil

-- Module for netcache_nc_value_5_address struct
local netcache_nc_value_5Header = initHeader()
netcache_nc_value_5Header.__index = netcache_nc_value_5Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netcache_nc_value_5Header:getVALUE_5_1()
	return hton(self.value_5_1)
end

function netcache_nc_value_5Header:getVALUE_5_1string()
	return self:getVALUE_5_1()
end

function netcache_nc_value_5Header:setVALUE_5_1(int)
	int = int or 0
	self.value_5_1 = hton(int)
end


function netcache_nc_value_5Header:getVALUE_5_2()
	return hton(self.value_5_2)
end

function netcache_nc_value_5Header:getVALUE_5_2string()
	return self:getVALUE_5_2()
end

function netcache_nc_value_5Header:setVALUE_5_2(int)
	int = int or 0
	self.value_5_2 = hton(int)
end


function netcache_nc_value_5Header:getVALUE_5_3()
	return hton(self.value_5_3)
end

function netcache_nc_value_5Header:getVALUE_5_3string()
	return self:getVALUE_5_3()
end

function netcache_nc_value_5Header:setVALUE_5_3(int)
	int = int or 0
	self.value_5_3 = hton(int)
end


function netcache_nc_value_5Header:getVALUE_5_4()
	return hton(self.value_5_4)
end

function netcache_nc_value_5Header:getVALUE_5_4string()
	return self:getVALUE_5_4()
end

function netcache_nc_value_5Header:setVALUE_5_4(int)
	int = int or 0
	self.value_5_4 = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netcache_nc_value_5Header:fill(args,pre)
	args = args or {}
	pre = pre or 'netcache_nc_value_5'

	self:setVALUE_5_1(args[pre .. 'VALUE_5_1'])
	self:setVALUE_5_2(args[pre .. 'VALUE_5_2'])
	self:setVALUE_5_3(args[pre .. 'VALUE_5_3'])
	self:setVALUE_5_4(args[pre .. 'VALUE_5_4'])
end

-- Retrieve the values of all members
function netcache_nc_value_5Header:get(pre)
	pre = pre or 'netcache_nc_value_5'

	local args = {}
	args[pre .. 'VALUE_5_1'] = self:getVALUE_5_1()
	args[pre .. 'VALUE_5_2'] = self:getVALUE_5_2()
	args[pre .. 'VALUE_5_3'] = self:getVALUE_5_3()
	args[pre .. 'VALUE_5_4'] = self:getVALUE_5_4()

	return args
end

function netcache_nc_value_5Header:getString()
	return 'netcache_nc_value_5 \n'
		.. 'VALUE_5_1' .. self:getVALUE_5_1String() .. '\n'
		.. 'VALUE_5_2' .. self:getVALUE_5_2String() .. '\n'
		.. 'VALUE_5_3' .. self:getVALUE_5_3String() .. '\n'
		.. 'VALUE_5_4' .. self:getVALUE_5_4String() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function netcache_nc_value_5Header:resolveNextHeader()
	return nc_value_6
end

function netcache_nc_value_5Header:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netcache_nc_value_5.metatype = netcache_nc_value_5Header

return netcache_nc_value_5