--Template for addition of new protocol 'lr_msg_type'

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
---- linear_road_lr_msg_type header and constants 
-----------------------------------------------------
local linear_road_lr_msg_type = {}

linear_road_lr_msg_type.headerFormat = [[
	uint8_t 	 msg_type;
]]


-- variable length fields
linear_road_lr_msg_type.headerVariableMember = nil

-- Module for linear_road_lr_msg_type_address struct
local linear_road_lr_msg_typeHeader = initHeader()
linear_road_lr_msg_typeHeader.__index = linear_road_lr_msg_typeHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function linear_road_lr_msg_typeHeader:getMSG_TYPE()
	return (self.msg_type)
end

function linear_road_lr_msg_typeHeader:getMSG_TYPEstring()
	return self:getMSG_TYPE()
end

function linear_road_lr_msg_typeHeader:setMSG_TYPE(int)
	int = int or 0
	self.msg_type = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function linear_road_lr_msg_typeHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'linear_road_lr_msg_type'

	self:setMSG_TYPE(args[pre .. 'MSG_TYPE'])
end

-- Retrieve the values of all members
function linear_road_lr_msg_typeHeader:get(pre)
	pre = pre or 'linear_road_lr_msg_type'

	local args = {}
	args[pre .. 'MSG_TYPE'] = self:getMSG_TYPE()

	return args
end

function linear_road_lr_msg_typeHeader:getString()
	return 'linear_road_lr_msg_type \n'
		.. 'MSG_TYPE' .. self:getMSG_TYPEString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	linear_road_pos_report = 0x00,
	linear_road_accnt_bal_req = 0x02,
	linear_road_toll_notification = 0x0a,
	linear_road_accident_alert = 0x0b,
	linear_road_accnt_bal = 0x0c,
	linear_road_expenditure_req = 0x03,
	linear_road_expenditure_report = 0x0d,
	linear_road_travel_estimate_req = 0x04,
	linear_road_travel_estimate = 0x0e,
}
function linear_road_lr_msg_typeHeader:resolveNextHeader()
	local key = self:getMSG_TYPE()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function linear_road_lr_msg_typeHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'MSG_TYPE'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'MSG_TYPE'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
linear_road_lr_msg_type.metatype = linear_road_lr_msg_typeHeader

return linear_road_lr_msg_type