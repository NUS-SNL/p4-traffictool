--Template for addition of new protocol 'ipv4_option'

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
---- mri_ipv4_option header and constants 
-----------------------------------------------------
local mri_ipv4_option = {}

mri_ipv4_option.headerFormat = [[
	uint8_t 	 copyFlag;
	uint8_t 	 optClass;
	uint8_t 	 option;
	uint8_t 	 optionLength;
]]


-- variable length fields
mri_ipv4_option.headerVariableMember = nil

-- Module for mri_ipv4_option_address struct
local mri_ipv4_optionHeader = initHeader()
mri_ipv4_optionHeader.__index = mri_ipv4_optionHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function mri_ipv4_optionHeader:getCOPYFLAG()
	return (self.copyFlag)
end

function mri_ipv4_optionHeader:getCOPYFLAGstring()
	return self:getCOPYFLAG()
end

function mri_ipv4_optionHeader:setCOPYFLAG(int)
	int = int or 0
	self.copyFlag = (int)
end


function mri_ipv4_optionHeader:getOPTCLASS()
	return (self.optClass)
end

function mri_ipv4_optionHeader:getOPTCLASSstring()
	return self:getOPTCLASS()
end

function mri_ipv4_optionHeader:setOPTCLASS(int)
	int = int or 0
	self.optClass = (int)
end


function mri_ipv4_optionHeader:getOPTION()
	return (self.option)
end

function mri_ipv4_optionHeader:getOPTIONstring()
	return self:getOPTION()
end

function mri_ipv4_optionHeader:setOPTION(int)
	int = int or 0
	self.option = (int)
end


function mri_ipv4_optionHeader:getOPTIONLENGTH()
	return (self.optionLength)
end

function mri_ipv4_optionHeader:getOPTIONLENGTHstring()
	return self:getOPTIONLENGTH()
end

function mri_ipv4_optionHeader:setOPTIONLENGTH(int)
	int = int or 0
	self.optionLength = (int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function mri_ipv4_optionHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'mri_ipv4_option'

	self:setCOPYFLAG(args[pre .. 'COPYFLAG'])
	self:setOPTCLASS(args[pre .. 'OPTCLASS'])
	self:setOPTION(args[pre .. 'OPTION'])
	self:setOPTIONLENGTH(args[pre .. 'OPTIONLENGTH'])
end

-- Retrieve the values of all members
function mri_ipv4_optionHeader:get(pre)
	pre = pre or 'mri_ipv4_option'

	local args = {}
	args[pre .. 'COPYFLAG'] = self:getCOPYFLAG()
	args[pre .. 'OPTCLASS'] = self:getOPTCLASS()
	args[pre .. 'OPTION'] = self:getOPTION()
	args[pre .. 'OPTIONLENGTH'] = self:getOPTIONLENGTH()

	return args
end

function mri_ipv4_optionHeader:getString()
	return 'mri_ipv4_option \n'
		.. 'COPYFLAG' .. self:getCOPYFLAGString() .. '\n'
		.. 'OPTCLASS' .. self:getOPTCLASSString() .. '\n'
		.. 'OPTION' .. self:getOPTIONString() .. '\n'
		.. 'OPTIONLENGTH' .. self:getOPTIONLENGTHString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	mri_mri = 0x1f,
}
function mri_ipv4_optionHeader:resolveNextHeader()
	local key = self:getOPTION()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function mri_ipv4_optionHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'OPTION'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'OPTION'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
mri_ipv4_option.metatype = mri_ipv4_optionHeader

return mri_ipv4_option