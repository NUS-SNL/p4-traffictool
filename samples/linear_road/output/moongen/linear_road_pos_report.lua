--Template for addition of new protocol 'pos_report'

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
---- linear_road_pos_report header and constants 
-----------------------------------------------------
local linear_road_pos_report = {}

linear_road_pos_report.headerFormat = [[
	uint16_t 	 time;
	uint32_t 	 vid;
	uint8_t 	 spd;
	uint8_t 	 xway;
	uint8_t 	 lane;
	uint8_t 	 dir;
	uint8_t 	 seg;
]]


-- variable length fields
linear_road_pos_report.headerVariableMember = nil

-- Module for linear_road_pos_report_address struct
local linear_road_pos_reportHeader = initHeader()
linear_road_pos_reportHeader.__index = linear_road_pos_reportHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_pos_reportHeader:getTIME()
	return hton16(self.time)
end

function linear_road_pos_reportHeader:getTIMEstring()
	return self:getTIME()
end

function linear_road_pos_reportHeader:setTIME(int)
	int = int or 0
	self.time = hton16(int)
end


function linear_road_pos_reportHeader:getVID()
	return hton(self.vid)
end

function linear_road_pos_reportHeader:getVIDstring()
	return self:getVID()
end

function linear_road_pos_reportHeader:setVID(int)
	int = int or 0
	self.vid = hton(int)
end


function linear_road_pos_reportHeader:getSPD()
	return (self.spd)
end

function linear_road_pos_reportHeader:getSPDstring()
	return self:getSPD()
end

function linear_road_pos_reportHeader:setSPD(int)
	int = int or 0
	self.spd = (int)
end


function linear_road_pos_reportHeader:getXWAY()
	return (self.xway)
end

function linear_road_pos_reportHeader:getXWAYstring()
	return self:getXWAY()
end

function linear_road_pos_reportHeader:setXWAY(int)
	int = int or 0
	self.xway = (int)
end


function linear_road_pos_reportHeader:getLANE()
	return (self.lane)
end

function linear_road_pos_reportHeader:getLANEstring()
	return self:getLANE()
end

function linear_road_pos_reportHeader:setLANE(int)
	int = int or 0
	self.lane = (int)
end


function linear_road_pos_reportHeader:getDIR()
	return (self.dir)
end

function linear_road_pos_reportHeader:getDIRstring()
	return self:getDIR()
end

function linear_road_pos_reportHeader:setDIR(int)
	int = int or 0
	self.dir = (int)
end


function linear_road_pos_reportHeader:getSEG()
	return (self.seg)
end

function linear_road_pos_reportHeader:getSEGstring()
	return self:getSEG()
end

function linear_road_pos_reportHeader:setSEG(int)
	int = int or 0
	self.seg = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_pos_reportHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'linear_road_pos_report'

	self:setTIME(args[pre .. 'TIME'])
	self:setVID(args[pre .. 'VID'])
	self:setSPD(args[pre .. 'SPD'])
	self:setXWAY(args[pre .. 'XWAY'])
	self:setLANE(args[pre .. 'LANE'])
	self:setDIR(args[pre .. 'DIR'])
	self:setSEG(args[pre .. 'SEG'])
end

-- Retrieve the values of all members
function linear_road_pos_reportHeader:get(pre)
	pre = pre or 'linear_road_pos_report'

	local args = {}
	args[pre .. 'TIME'] = self:getTIME()
	args[pre .. 'VID'] = self:getVID()
	args[pre .. 'SPD'] = self:getSPD()
	args[pre .. 'XWAY'] = self:getXWAY()
	args[pre .. 'LANE'] = self:getLANE()
	args[pre .. 'DIR'] = self:getDIR()
	args[pre .. 'SEG'] = self:getSEG()

	return args
end

function linear_road_pos_reportHeader:getString()
	return 'linear_road_pos_report \n'
		.. 'TIME' .. self:getTIMEString() .. '\n'
		.. 'VID' .. self:getVIDString() .. '\n'
		.. 'SPD' .. self:getSPDString() .. '\n'
		.. 'XWAY' .. self:getXWAYString() .. '\n'
		.. 'LANE' .. self:getLANEString() .. '\n'
		.. 'DIR' .. self:getDIRString() .. '\n'
		.. 'SEG' .. self:getSEGString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_pos_reportHeader:resolveNextHeader()
	return nil
end

function linear_road_pos_reportHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_pos_report.metatype = linear_road_pos_reportHeader

return linear_road_pos_report