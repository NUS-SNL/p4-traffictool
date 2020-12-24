--Template for addition of new protocol 'toll_notification'

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
---- linear_road_toll_notification header and constants 
-----------------------------------------------------
local linear_road_toll_notification = {}

linear_road_toll_notification.headerFormat = [[
    uint16_t      time;
    uint32_t      vid;
    uint16_t      emit;
    uint8_t      spd;
    uint16_t      toll;
]]


-- variable length fields
linear_road_toll_notification.headerVariableMember = nil

-- Module for linear_road_toll_notification_address struct
local linear_road_toll_notificationHeader = initHeader()
linear_road_toll_notificationHeader.__index = linear_road_toll_notificationHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_toll_notificationHeader:getTIME()
    return hton16(self.time)
end

function linear_road_toll_notificationHeader:getTIMEstring()
    return self:getTIME()
end

function linear_road_toll_notificationHeader:setTIME(int)
    int = int or 0
    self.time = hton16(int)
end


function linear_road_toll_notificationHeader:getVID()
    return hton(self.vid)
end

function linear_road_toll_notificationHeader:getVIDstring()
    return self:getVID()
end

function linear_road_toll_notificationHeader:setVID(int)
    int = int or 0
    self.vid = hton(int)
end


function linear_road_toll_notificationHeader:getEMIT()
    return hton16(self.emit)
end

function linear_road_toll_notificationHeader:getEMITstring()
    return self:getEMIT()
end

function linear_road_toll_notificationHeader:setEMIT(int)
    int = int or 0
    self.emit = hton16(int)
end


function linear_road_toll_notificationHeader:getSPD()
    return (self.spd)
end

function linear_road_toll_notificationHeader:getSPDstring()
    return self:getSPD()
end

function linear_road_toll_notificationHeader:setSPD(int)
    int = int or 0
    self.spd = (int)
end


function linear_road_toll_notificationHeader:getTOLL()
    return hton16(self.toll)
end

function linear_road_toll_notificationHeader:getTOLLstring()
    return self:getTOLL()
end

function linear_road_toll_notificationHeader:setTOLL(int)
    int = int or 0
    self.toll = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_toll_notificationHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'linear_road_toll_notification'

    self:setTIME(args[pre .. 'TIME'])
    self:setVID(args[pre .. 'VID'])
    self:setEMIT(args[pre .. 'EMIT'])
    self:setSPD(args[pre .. 'SPD'])
    self:setTOLL(args[pre .. 'TOLL'])
end

-- Retrieve the values of all members
function linear_road_toll_notificationHeader:get(pre)
    pre = pre or 'linear_road_toll_notification'

    local args = {}
    args[pre .. 'TIME'] = self:getTIME()
    args[pre .. 'VID'] = self:getVID()
    args[pre .. 'EMIT'] = self:getEMIT()
    args[pre .. 'SPD'] = self:getSPD()
    args[pre .. 'TOLL'] = self:getTOLL()

    return args
end

function linear_road_toll_notificationHeader:getString()
    return 'linear_road_toll_notification \n'
        .. 'TIME' .. self:getTIMEString() .. '\n'
        .. 'VID' .. self:getVIDString() .. '\n'
        .. 'EMIT' .. self:getEMITString() .. '\n'
        .. 'SPD' .. self:getSPDString() .. '\n'
        .. 'TOLL' .. self:getTOLLString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_toll_notificationHeader:resolveNextHeader()
    return nil
end

function linear_road_toll_notificationHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_toll_notification.metatype = linear_road_toll_notificationHeader

return linear_road_toll_notification