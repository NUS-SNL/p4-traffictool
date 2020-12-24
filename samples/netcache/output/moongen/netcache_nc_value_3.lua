--Template for addition of new protocol 'nc_value_3'

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
---- netcache_nc_value_3 header and constants 
-----------------------------------------------------
local netcache_nc_value_3 = {}

netcache_nc_value_3.headerFormat = [[
    uint32_t      value_3_1;
    uint32_t      value_3_2;
    uint32_t      value_3_3;
    uint32_t      value_3_4;
]]


-- variable length fields
netcache_nc_value_3.headerVariableMember = nil

-- Module for netcache_nc_value_3_address struct
local netcache_nc_value_3Header = initHeader()
netcache_nc_value_3Header.__index = netcache_nc_value_3Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netcache_nc_value_3Header:getVALUE_3_1()
    return hton(self.value_3_1)
end

function netcache_nc_value_3Header:getVALUE_3_1string()
    return self:getVALUE_3_1()
end

function netcache_nc_value_3Header:setVALUE_3_1(int)
    int = int or 0
    self.value_3_1 = hton(int)
end


function netcache_nc_value_3Header:getVALUE_3_2()
    return hton(self.value_3_2)
end

function netcache_nc_value_3Header:getVALUE_3_2string()
    return self:getVALUE_3_2()
end

function netcache_nc_value_3Header:setVALUE_3_2(int)
    int = int or 0
    self.value_3_2 = hton(int)
end


function netcache_nc_value_3Header:getVALUE_3_3()
    return hton(self.value_3_3)
end

function netcache_nc_value_3Header:getVALUE_3_3string()
    return self:getVALUE_3_3()
end

function netcache_nc_value_3Header:setVALUE_3_3(int)
    int = int or 0
    self.value_3_3 = hton(int)
end


function netcache_nc_value_3Header:getVALUE_3_4()
    return hton(self.value_3_4)
end

function netcache_nc_value_3Header:getVALUE_3_4string()
    return self:getVALUE_3_4()
end

function netcache_nc_value_3Header:setVALUE_3_4(int)
    int = int or 0
    self.value_3_4 = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netcache_nc_value_3Header:fill(args,pre)
    args = args or {}
    pre = pre or 'netcache_nc_value_3'

    self:setVALUE_3_1(args[pre .. 'VALUE_3_1'])
    self:setVALUE_3_2(args[pre .. 'VALUE_3_2'])
    self:setVALUE_3_3(args[pre .. 'VALUE_3_3'])
    self:setVALUE_3_4(args[pre .. 'VALUE_3_4'])
end

-- Retrieve the values of all members
function netcache_nc_value_3Header:get(pre)
    pre = pre or 'netcache_nc_value_3'

    local args = {}
    args[pre .. 'VALUE_3_1'] = self:getVALUE_3_1()
    args[pre .. 'VALUE_3_2'] = self:getVALUE_3_2()
    args[pre .. 'VALUE_3_3'] = self:getVALUE_3_3()
    args[pre .. 'VALUE_3_4'] = self:getVALUE_3_4()

    return args
end

function netcache_nc_value_3Header:getString()
    return 'netcache_nc_value_3 \n'
        .. 'VALUE_3_1' .. self:getVALUE_3_1String() .. '\n'
        .. 'VALUE_3_2' .. self:getVALUE_3_2String() .. '\n'
        .. 'VALUE_3_3' .. self:getVALUE_3_3String() .. '\n'
        .. 'VALUE_3_4' .. self:getVALUE_3_4String() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function netcache_nc_value_3Header:resolveNextHeader()
    return nc_value_4
end

function netcache_nc_value_3Header:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netcache_nc_value_3.metatype = netcache_nc_value_3Header

return netcache_nc_value_3