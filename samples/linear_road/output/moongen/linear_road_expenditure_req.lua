--Template for addition of new protocol 'expenditure_req'

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
---- linear_road_expenditure_req header and constants 
-----------------------------------------------------
local linear_road_expenditure_req = {}

linear_road_expenditure_req.headerFormat = [[
    uint16_t      time;
    uint32_t      vid;
    uint32_t      qid;
    uint8_t      xway;
    uint8_t      day;
]]


-- variable length fields
linear_road_expenditure_req.headerVariableMember = nil

-- Module for linear_road_expenditure_req_address struct
local linear_road_expenditure_reqHeader = initHeader()
linear_road_expenditure_reqHeader.__index = linear_road_expenditure_reqHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_expenditure_reqHeader:getTIME()
    return hton16(self.time)
end

function linear_road_expenditure_reqHeader:getTIMEstring()
    return self:getTIME()
end

function linear_road_expenditure_reqHeader:setTIME(int)
    int = int or 0
    self.time = hton16(int)
end


function linear_road_expenditure_reqHeader:getVID()
    return hton(self.vid)
end

function linear_road_expenditure_reqHeader:getVIDstring()
    return self:getVID()
end

function linear_road_expenditure_reqHeader:setVID(int)
    int = int or 0
    self.vid = hton(int)
end


function linear_road_expenditure_reqHeader:getQID()
    return hton(self.qid)
end

function linear_road_expenditure_reqHeader:getQIDstring()
    return self:getQID()
end

function linear_road_expenditure_reqHeader:setQID(int)
    int = int or 0
    self.qid = hton(int)
end


function linear_road_expenditure_reqHeader:getXWAY()
    return (self.xway)
end

function linear_road_expenditure_reqHeader:getXWAYstring()
    return self:getXWAY()
end

function linear_road_expenditure_reqHeader:setXWAY(int)
    int = int or 0
    self.xway = (int)
end


function linear_road_expenditure_reqHeader:getDAY()
    return (self.day)
end

function linear_road_expenditure_reqHeader:getDAYstring()
    return self:getDAY()
end

function linear_road_expenditure_reqHeader:setDAY(int)
    int = int or 0
    self.day = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_expenditure_reqHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'linear_road_expenditure_req'

    self:setTIME(args[pre .. 'TIME'])
    self:setVID(args[pre .. 'VID'])
    self:setQID(args[pre .. 'QID'])
    self:setXWAY(args[pre .. 'XWAY'])
    self:setDAY(args[pre .. 'DAY'])
end

-- Retrieve the values of all members
function linear_road_expenditure_reqHeader:get(pre)
    pre = pre or 'linear_road_expenditure_req'

    local args = {}
    args[pre .. 'TIME'] = self:getTIME()
    args[pre .. 'VID'] = self:getVID()
    args[pre .. 'QID'] = self:getQID()
    args[pre .. 'XWAY'] = self:getXWAY()
    args[pre .. 'DAY'] = self:getDAY()

    return args
end

function linear_road_expenditure_reqHeader:getString()
    return 'linear_road_expenditure_req \n'
        .. 'TIME' .. self:getTIMEString() .. '\n'
        .. 'VID' .. self:getVIDString() .. '\n'
        .. 'QID' .. self:getQIDString() .. '\n'
        .. 'XWAY' .. self:getXWAYString() .. '\n'
        .. 'DAY' .. self:getDAYString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_expenditure_reqHeader:resolveNextHeader()
    return nil
end

function linear_road_expenditure_reqHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_expenditure_req.metatype = linear_road_expenditure_reqHeader

return linear_road_expenditure_req