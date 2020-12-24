--Template for addition of new protocol 'travel_estimate_req'

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
---- linear_road_travel_estimate_req header and constants 
-----------------------------------------------------
local linear_road_travel_estimate_req = {}

linear_road_travel_estimate_req.headerFormat = [[
    uint16_t      time;
    uint32_t      qid;
    uint8_t      xway;
    uint8_t      seg_init;
    uint8_t      seg_end;
    uint8_t      dow;
    uint8_t      tod;
]]


-- variable length fields
linear_road_travel_estimate_req.headerVariableMember = nil

-- Module for linear_road_travel_estimate_req_address struct
local linear_road_travel_estimate_reqHeader = initHeader()
linear_road_travel_estimate_reqHeader.__index = linear_road_travel_estimate_reqHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_travel_estimate_reqHeader:getTIME()
    return hton16(self.time)
end

function linear_road_travel_estimate_reqHeader:getTIMEstring()
    return self:getTIME()
end

function linear_road_travel_estimate_reqHeader:setTIME(int)
    int = int or 0
    self.time = hton16(int)
end


function linear_road_travel_estimate_reqHeader:getQID()
    return hton(self.qid)
end

function linear_road_travel_estimate_reqHeader:getQIDstring()
    return self:getQID()
end

function linear_road_travel_estimate_reqHeader:setQID(int)
    int = int or 0
    self.qid = hton(int)
end


function linear_road_travel_estimate_reqHeader:getXWAY()
    return (self.xway)
end

function linear_road_travel_estimate_reqHeader:getXWAYstring()
    return self:getXWAY()
end

function linear_road_travel_estimate_reqHeader:setXWAY(int)
    int = int or 0
    self.xway = (int)
end


function linear_road_travel_estimate_reqHeader:getSEG_INIT()
    return (self.seg_init)
end

function linear_road_travel_estimate_reqHeader:getSEG_INITstring()
    return self:getSEG_INIT()
end

function linear_road_travel_estimate_reqHeader:setSEG_INIT(int)
    int = int or 0
    self.seg_init = (int)
end


function linear_road_travel_estimate_reqHeader:getSEG_END()
    return (self.seg_end)
end

function linear_road_travel_estimate_reqHeader:getSEG_ENDstring()
    return self:getSEG_END()
end

function linear_road_travel_estimate_reqHeader:setSEG_END(int)
    int = int or 0
    self.seg_end = (int)
end


function linear_road_travel_estimate_reqHeader:getDOW()
    return (self.dow)
end

function linear_road_travel_estimate_reqHeader:getDOWstring()
    return self:getDOW()
end

function linear_road_travel_estimate_reqHeader:setDOW(int)
    int = int or 0
    self.dow = (int)
end


function linear_road_travel_estimate_reqHeader:getTOD()
    return (self.tod)
end

function linear_road_travel_estimate_reqHeader:getTODstring()
    return self:getTOD()
end

function linear_road_travel_estimate_reqHeader:setTOD(int)
    int = int or 0
    self.tod = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_travel_estimate_reqHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'linear_road_travel_estimate_req'

    self:setTIME(args[pre .. 'TIME'])
    self:setQID(args[pre .. 'QID'])
    self:setXWAY(args[pre .. 'XWAY'])
    self:setSEG_INIT(args[pre .. 'SEG_INIT'])
    self:setSEG_END(args[pre .. 'SEG_END'])
    self:setDOW(args[pre .. 'DOW'])
    self:setTOD(args[pre .. 'TOD'])
end

-- Retrieve the values of all members
function linear_road_travel_estimate_reqHeader:get(pre)
    pre = pre or 'linear_road_travel_estimate_req'

    local args = {}
    args[pre .. 'TIME'] = self:getTIME()
    args[pre .. 'QID'] = self:getQID()
    args[pre .. 'XWAY'] = self:getXWAY()
    args[pre .. 'SEG_INIT'] = self:getSEG_INIT()
    args[pre .. 'SEG_END'] = self:getSEG_END()
    args[pre .. 'DOW'] = self:getDOW()
    args[pre .. 'TOD'] = self:getTOD()

    return args
end

function linear_road_travel_estimate_reqHeader:getString()
    return 'linear_road_travel_estimate_req \n'
        .. 'TIME' .. self:getTIMEString() .. '\n'
        .. 'QID' .. self:getQIDString() .. '\n'
        .. 'XWAY' .. self:getXWAYString() .. '\n'
        .. 'SEG_INIT' .. self:getSEG_INITString() .. '\n'
        .. 'SEG_END' .. self:getSEG_ENDString() .. '\n'
        .. 'DOW' .. self:getDOWString() .. '\n'
        .. 'TOD' .. self:getTODString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_travel_estimate_reqHeader:resolveNextHeader()
    return nil
end

function linear_road_travel_estimate_reqHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_travel_estimate_req.metatype = linear_road_travel_estimate_reqHeader

return linear_road_travel_estimate_req