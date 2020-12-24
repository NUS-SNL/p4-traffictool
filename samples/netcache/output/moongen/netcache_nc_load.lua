--Template for addition of new protocol 'nc_load'

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
---- netcache_nc_load header and constants 
-----------------------------------------------------
local netcache_nc_load = {}

netcache_nc_load.headerFormat = [[
    uint32_t      load_1;
    uint32_t      load_2;
    uint32_t      load_3;
    uint32_t      load_4;
]]


-- variable length fields
netcache_nc_load.headerVariableMember = nil

-- Module for netcache_nc_load_address struct
local netcache_nc_loadHeader = initHeader()
netcache_nc_loadHeader.__index = netcache_nc_loadHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netcache_nc_loadHeader:getLOAD_1()
    return hton(self.load_1)
end

function netcache_nc_loadHeader:getLOAD_1string()
    return self:getLOAD_1()
end

function netcache_nc_loadHeader:setLOAD_1(int)
    int = int or 0
    self.load_1 = hton(int)
end


function netcache_nc_loadHeader:getLOAD_2()
    return hton(self.load_2)
end

function netcache_nc_loadHeader:getLOAD_2string()
    return self:getLOAD_2()
end

function netcache_nc_loadHeader:setLOAD_2(int)
    int = int or 0
    self.load_2 = hton(int)
end


function netcache_nc_loadHeader:getLOAD_3()
    return hton(self.load_3)
end

function netcache_nc_loadHeader:getLOAD_3string()
    return self:getLOAD_3()
end

function netcache_nc_loadHeader:setLOAD_3(int)
    int = int or 0
    self.load_3 = hton(int)
end


function netcache_nc_loadHeader:getLOAD_4()
    return hton(self.load_4)
end

function netcache_nc_loadHeader:getLOAD_4string()
    return self:getLOAD_4()
end

function netcache_nc_loadHeader:setLOAD_4(int)
    int = int or 0
    self.load_4 = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netcache_nc_loadHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'netcache_nc_load'

    self:setLOAD_1(args[pre .. 'LOAD_1'])
    self:setLOAD_2(args[pre .. 'LOAD_2'])
    self:setLOAD_3(args[pre .. 'LOAD_3'])
    self:setLOAD_4(args[pre .. 'LOAD_4'])
end

-- Retrieve the values of all members
function netcache_nc_loadHeader:get(pre)
    pre = pre or 'netcache_nc_load'

    local args = {}
    args[pre .. 'LOAD_1'] = self:getLOAD_1()
    args[pre .. 'LOAD_2'] = self:getLOAD_2()
    args[pre .. 'LOAD_3'] = self:getLOAD_3()
    args[pre .. 'LOAD_4'] = self:getLOAD_4()

    return args
end

function netcache_nc_loadHeader:getString()
    return 'netcache_nc_load \n'
        .. 'LOAD_1' .. self:getLOAD_1String() .. '\n'
        .. 'LOAD_2' .. self:getLOAD_2String() .. '\n'
        .. 'LOAD_3' .. self:getLOAD_3String() .. '\n'
        .. 'LOAD_4' .. self:getLOAD_4String() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function netcache_nc_loadHeader:resolveNextHeader()
    return nil
end

function netcache_nc_loadHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netcache_nc_load.metatype = netcache_nc_loadHeader

return netcache_nc_load