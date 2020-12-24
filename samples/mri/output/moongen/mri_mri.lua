--Template for addition of new protocol 'mri'

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
---- mri_mri header and constants 
-----------------------------------------------------
local mri_mri = {}

mri_mri.headerFormat = [[
    uint16_t      count;
]]


-- variable length fields
mri_mri.headerVariableMember = nil

-- Module for mri_mri_address struct
local mri_mriHeader = initHeader()
mri_mriHeader.__index = mri_mriHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function mri_mriHeader:getCOUNT()
    return hton16(self.count)
end

function mri_mriHeader:getCOUNTstring()
    return self:getCOUNT()
end

function mri_mriHeader:setCOUNT(int)
    int = int or 0
    self.count = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function mri_mriHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'mri_mri'

    self:setCOUNT(args[pre .. 'COUNT'])
end

-- Retrieve the values of all members
function mri_mriHeader:get(pre)
    pre = pre or 'mri_mri'

    local args = {}
    args[pre .. 'COUNT'] = self:getCOUNT()

    return args
end

function mri_mriHeader:getString()
    return 'mri_mri \n'
        .. 'COUNT' .. self:getCOUNTString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
    mri_swids = default,
}
function mri_mriHeader:resolveNextHeader()
    local key = self:getCOUNT()
    for name, value in pairs(nextHeaderResolve) do
        if key == value then
            return name
        end
    end
    return nil
end

function mri_mriHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    if not namedArgs[pre .. 'COUNT'] then
        for name, _port in pairs(nextHeaderResolve) do
            if nextHeader == name then
                namedArgs[pre .. 'COUNT'] = _port
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
mri_mri.metatype = mri_mriHeader

return mri_mri