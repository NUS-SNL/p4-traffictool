--Template for addition of new protocol 'nc_value_4'

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
---- netcache_nc_value_4 header and constants 
-----------------------------------------------------
local netcache_nc_value_4 = {}

netcache_nc_value_4.headerFormat = [[
    uint32_t      value_4_1;
    uint32_t      value_4_2;
    uint32_t      value_4_3;
    uint32_t      value_4_4;
]]


-- variable length fields
netcache_nc_value_4.headerVariableMember = nil

-- Module for netcache_nc_value_4_address struct
local netcache_nc_value_4Header = initHeader()
netcache_nc_value_4Header.__index = netcache_nc_value_4Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netcache_nc_value_4Header:getVALUE_4_1()
    return hton(self.value_4_1)
end

function netcache_nc_value_4Header:getVALUE_4_1string()
    return self:getVALUE_4_1()
end

function netcache_nc_value_4Header:setVALUE_4_1(int)
    int = int or 0
    self.value_4_1 = hton(int)
end


function netcache_nc_value_4Header:getVALUE_4_2()
    return hton(self.value_4_2)
end

function netcache_nc_value_4Header:getVALUE_4_2string()
    return self:getVALUE_4_2()
end

function netcache_nc_value_4Header:setVALUE_4_2(int)
    int = int or 0
    self.value_4_2 = hton(int)
end


function netcache_nc_value_4Header:getVALUE_4_3()
    return hton(self.value_4_3)
end

function netcache_nc_value_4Header:getVALUE_4_3string()
    return self:getVALUE_4_3()
end

function netcache_nc_value_4Header:setVALUE_4_3(int)
    int = int or 0
    self.value_4_3 = hton(int)
end


function netcache_nc_value_4Header:getVALUE_4_4()
    return hton(self.value_4_4)
end

function netcache_nc_value_4Header:getVALUE_4_4string()
    return self:getVALUE_4_4()
end

function netcache_nc_value_4Header:setVALUE_4_4(int)
    int = int or 0
    self.value_4_4 = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netcache_nc_value_4Header:fill(args,pre)
    args = args or {}
    pre = pre or 'netcache_nc_value_4'

    self:setVALUE_4_1(args[pre .. 'VALUE_4_1'])
    self:setVALUE_4_2(args[pre .. 'VALUE_4_2'])
    self:setVALUE_4_3(args[pre .. 'VALUE_4_3'])
    self:setVALUE_4_4(args[pre .. 'VALUE_4_4'])
end

-- Retrieve the values of all members
function netcache_nc_value_4Header:get(pre)
    pre = pre or 'netcache_nc_value_4'

    local args = {}
    args[pre .. 'VALUE_4_1'] = self:getVALUE_4_1()
    args[pre .. 'VALUE_4_2'] = self:getVALUE_4_2()
    args[pre .. 'VALUE_4_3'] = self:getVALUE_4_3()
    args[pre .. 'VALUE_4_4'] = self:getVALUE_4_4()

    return args
end

function netcache_nc_value_4Header:getString()
    return 'netcache_nc_value_4 \n'
        .. 'VALUE_4_1' .. self:getVALUE_4_1String() .. '\n'
        .. 'VALUE_4_2' .. self:getVALUE_4_2String() .. '\n'
        .. 'VALUE_4_3' .. self:getVALUE_4_3String() .. '\n'
        .. 'VALUE_4_4' .. self:getVALUE_4_4String() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function netcache_nc_value_4Header:resolveNextHeader()
    return nc_value_5
end

function netcache_nc_value_4Header:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netcache_nc_value_4.metatype = netcache_nc_value_4Header

return netcache_nc_value_4