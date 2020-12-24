--Template for addition of new protocol 'travel_estimate'

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
---- linear_road_travel_estimate header and constants 
-----------------------------------------------------
local linear_road_travel_estimate = {}

linear_road_travel_estimate.headerFormat = [[
    uint32_t      qid;
    uint16_t      travel_time;
    uint16_t      toll;
]]


-- variable length fields
linear_road_travel_estimate.headerVariableMember = nil

-- Module for linear_road_travel_estimate_address struct
local linear_road_travel_estimateHeader = initHeader()
linear_road_travel_estimateHeader.__index = linear_road_travel_estimateHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_travel_estimateHeader:getQID()
    return hton(self.qid)
end

function linear_road_travel_estimateHeader:getQIDstring()
    return self:getQID()
end

function linear_road_travel_estimateHeader:setQID(int)
    int = int or 0
    self.qid = hton(int)
end


function linear_road_travel_estimateHeader:getTRAVEL_TIME()
    return hton16(self.travel_time)
end

function linear_road_travel_estimateHeader:getTRAVEL_TIMEstring()
    return self:getTRAVEL_TIME()
end

function linear_road_travel_estimateHeader:setTRAVEL_TIME(int)
    int = int or 0
    self.travel_time = hton16(int)
end


function linear_road_travel_estimateHeader:getTOLL()
    return hton16(self.toll)
end

function linear_road_travel_estimateHeader:getTOLLstring()
    return self:getTOLL()
end

function linear_road_travel_estimateHeader:setTOLL(int)
    int = int or 0
    self.toll = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_travel_estimateHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'linear_road_travel_estimate'

    self:setQID(args[pre .. 'QID'])
    self:setTRAVEL_TIME(args[pre .. 'TRAVEL_TIME'])
    self:setTOLL(args[pre .. 'TOLL'])
end

-- Retrieve the values of all members
function linear_road_travel_estimateHeader:get(pre)
    pre = pre or 'linear_road_travel_estimate'

    local args = {}
    args[pre .. 'QID'] = self:getQID()
    args[pre .. 'TRAVEL_TIME'] = self:getTRAVEL_TIME()
    args[pre .. 'TOLL'] = self:getTOLL()

    return args
end

function linear_road_travel_estimateHeader:getString()
    return 'linear_road_travel_estimate \n'
        .. 'QID' .. self:getQIDString() .. '\n'
        .. 'TRAVEL_TIME' .. self:getTRAVEL_TIMEString() .. '\n'
        .. 'TOLL' .. self:getTOLLString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_travel_estimateHeader:resolveNextHeader()
    return nil
end

function linear_road_travel_estimateHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_travel_estimate.metatype = linear_road_travel_estimateHeader

return linear_road_travel_estimate