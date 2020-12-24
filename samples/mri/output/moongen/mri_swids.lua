--Template for addition of new protocol 'swids'

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
---- mri_swids header and constants 
-----------------------------------------------------
local mri_swids = {}

mri_swids.headerFormat = [[
    uint32_t      swid;
]]


-- variable length fields
mri_swids.headerVariableMember = nil

-- Module for mri_swids_address struct
local mri_swidsHeader = initHeader()
mri_swidsHeader.__index = mri_swidsHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function mri_swidsHeader:getSWID()
    return hton(self.swid)
end

function mri_swidsHeader:getSWIDstring()
    return self:getSWID()
end

function mri_swidsHeader:setSWID(int)
    int = int or 0
    self.swid = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function mri_swidsHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'mri_swids'

    self:setSWID(args[pre .. 'SWID'])
end

-- Retrieve the values of all members
function mri_swidsHeader:get(pre)
    pre = pre or 'mri_swids'

    local args = {}
    args[pre .. 'SWID'] = self:getSWID()

    return args
end

function mri_swidsHeader:getString()
    return 'mri_swids \n'
        .. 'SWID' .. self:getSWIDString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
    mri_swids = default,
}
function mri_swidsHeader:resolveNextHeader()
    for name, value in pairs(nextHeaderResolve) do
        if key == value then
            return name
        end
    end
    return nil
end

function mri_swidsHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    if not namedArgs[pre .. 'METADATA._PARSER_METADATA_REMAINING1'] then
        for name, _port in pairs(nextHeaderResolve) do
            if nextHeader == name then
                namedArgs[pre .. 'METADATA._PARSER_METADATA_REMAINING1'] = _port
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
mri_swids.metatype = mri_swidsHeader

return mri_swids