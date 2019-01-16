--Template for addition of new protocol 'accnt_bal'

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
---- linear_road_accnt_bal header and constants 
-----------------------------------------------------
local linear_road_accnt_bal = {}

linear_road_accnt_bal.headerFormat = [[
	uint16_t 	 time;
	uint32_t 	 vid;
	uint16_t 	 emit;
	uint32_t 	 qid;
	uint32_t 	 bal;
]]


-- variable length fields
linear_road_accnt_bal.headerVariableMember = nil

-- Module for linear_road_accnt_bal_address struct
local linear_road_accnt_balHeader = initHeader()
linear_road_accnt_balHeader.__index = linear_road_accnt_balHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_accnt_balHeader:getTIME()
	return hton16(self.time)
end

function linear_road_accnt_balHeader:getTIMEstring()
	return self:getTIME()
end

function linear_road_accnt_balHeader:setTIME(int)
	int = int or 0
	self.time = hton16(int)
end


function linear_road_accnt_balHeader:getVID()
	return hton(self.vid)
end

function linear_road_accnt_balHeader:getVIDstring()
	return self:getVID()
end

function linear_road_accnt_balHeader:setVID(int)
	int = int or 0
	self.vid = hton(int)
end


function linear_road_accnt_balHeader:getEMIT()
	return hton16(self.emit)
end

function linear_road_accnt_balHeader:getEMITstring()
	return self:getEMIT()
end

function linear_road_accnt_balHeader:setEMIT(int)
	int = int or 0
	self.emit = hton16(int)
end


function linear_road_accnt_balHeader:getQID()
	return hton(self.qid)
end

function linear_road_accnt_balHeader:getQIDstring()
	return self:getQID()
end

function linear_road_accnt_balHeader:setQID(int)
	int = int or 0
	self.qid = hton(int)
end


function linear_road_accnt_balHeader:getBAL()
	return hton(self.bal)
end

function linear_road_accnt_balHeader:getBALstring()
	return self:getBAL()
end

function linear_road_accnt_balHeader:setBAL(int)
	int = int or 0
	self.bal = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_accnt_balHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'linear_road_accnt_bal'

	self:setTIME(args[pre .. 'TIME'])
	self:setVID(args[pre .. 'VID'])
	self:setEMIT(args[pre .. 'EMIT'])
	self:setQID(args[pre .. 'QID'])
	self:setBAL(args[pre .. 'BAL'])
end

-- Retrieve the values of all members
function linear_road_accnt_balHeader:get(pre)
	pre = pre or 'linear_road_accnt_bal'

	local args = {}
	args[pre .. 'TIME'] = self:getTIME()
	args[pre .. 'VID'] = self:getVID()
	args[pre .. 'EMIT'] = self:getEMIT()
	args[pre .. 'QID'] = self:getQID()
	args[pre .. 'BAL'] = self:getBAL()

	return args
end

function linear_road_accnt_balHeader:getString()
	return 'linear_road_accnt_bal \n'
		.. 'TIME' .. self:getTIMEString() .. '\n'
		.. 'VID' .. self:getVIDString() .. '\n'
		.. 'EMIT' .. self:getEMITString() .. '\n'
		.. 'QID' .. self:getQIDString() .. '\n'
		.. 'BAL' .. self:getBALString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function linear_road_accnt_balHeader:resolveNextHeader()
	return nil
end

function linear_road_accnt_balHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_accnt_bal.metatype = linear_road_accnt_balHeader

return linear_road_accnt_bal