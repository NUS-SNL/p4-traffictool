--Template for addition of new protocol 'accident_alert'

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
---- linear_road_accident_alert header and constants 
-----------------------------------------------------
local linear_road_accident_alert = {}

linear_road_accident_alert.headerFormat = [[
    uint16_t      time;
    uint32_t      vid;
    uint16_t      emit;
    uint8_t      seg;
]]


-- variable length fields
linear_road_accident_alert.headerVariableMember = nil

-- Module for linear_road_accident_alert_address struct
local linear_road_accident_alertHeader = initHeader()
linear_road_accident_alertHeader.__index = linear_road_accident_alertHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_accident_alertHeader:getTIME()
    return hton16(self.time)
end

function linear_road_accident_alertHeader:getTIMEstring()
    return self:getTIME()
end

function linear_road_accident_alertHeader:setTIME(int)
    int = int or 0
    self.time = hton16(int)
end


function linear_road_accident_alertHeader:getVID()
    return hton(self.vid)
end

function linear_road_accident_alertHeader:getVIDstring()
    return self:getVID()
end

function linear_road_accident_alertHeader:setVID(int)
    int = int or 0
    self.vid = hton(int)
end


function linear_road_accident_alertHeader:getEMIT()
    return hton16(self.emit)
end

function linear_road_accident_alertHeader:getEMITstring()
    return self:getEMIT()
end

function linear_road_accident_alertHeader:setEMIT(int)
    int = int or 0
    self.emit = hton16(int)
end


function linear_road_accident_alertHeader:getSEG()
    return (self.seg)
end

function linear_road_accident_alertHeader:getSEGstring()
    return self:getSEG()
end

function linear_road_accident_alertHeader:setSEG(int)
    int = int or 0
    self.seg = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_accident_alertHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'linear_road_accident_alert'

    self:setTIME(args[pre .. 'TIME'])
    self:setVID(args[pre .. 'VID'])
    self:setEMIT(args[pre .. 'EMIT'])
    self:setSEG(args[pre .. 'SEG'])
end

-- Retrieve the values of all members
function linear_road_accident_alertHeader:get(pre)
    pre = pre or 'linear_road_accident_alert'

    local args = {}
    args[pre .. 'TIME'] = self:getTIME()
    args[pre .. 'VID'] = self:getVID()
    args[pre .. 'EMIT'] = self:getEMIT()
    args[pre .. 'SEG'] = self:getSEG()

    return args
end

function linear_road_accident_alertHeader:getString()
    return 'linear_road_accident_alert \n'
        .. 'TIME' .. self:getTIMEString() .. '\n'
        .. 'VID' .. self:getVIDString() .. '\n'
        .. 'EMIT' .. self:getEMITString() .. '\n'
        .. 'SEG' .. self:getSEGString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_accident_alertHeader:resolveNextHeader()
    return nil
end

function linear_road_accident_alertHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_accident_alert.metatype = linear_road_accident_alertHeader

return linear_road_accident_alert