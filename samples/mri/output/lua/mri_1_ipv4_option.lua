--Template for addition of new protocol 'ipv4_option'

--[[ Necessary changes to other files:
-- - packet.lua: if the header has a length member, adapt packetSetLength; 
-- 				 if the packet has a checksum, adapt createStack (loop at end of function) and packetCalculateChecksums
-- - proto/proto.lua: add PROTO.lua to the list so it gets loaded
--]]

local ffi = require "ffi"
local dpdkc = require "dpdkc"

require "utils"
require "proto.template"
local initHeader = initHeader

local ntoh, hton = ntoh, hton
local ntoh16, hton16 = ntoh16, hton16
local bor, band, bnot, rshift, lshift= bit.bor, bit.band, bit.bnot, bit.rshift, bit.lshift
local istype = ffi.istype
local format = string.format

-----------------------------------------------------
---- IPV4_OPTION header and constants 
-----------------------------------------------------
local IPV4_OPTION = {}

IPV4_OPTION.headerFormat = [[
	1 	 copyFlag;
	2 	 optClass;
	5 	 option;
	8 	 optionLength;
]]


-- variable length fields
IPV4_OPTION.headerVariableMember = nil

-- Module for IPV4_OPTION_address struct
local IPV4_OPTIONHeader = initHeader()
IPV4_OPTIONHeader.__index = IPV4_OPTIONHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTIONHeader:getCOPYFLAG()
	return hton(self.copyFlag)
end

function IPV4_OPTIONHeader:getCOPYFLAGstring()
	return self:getCOPYFLAG()
end

function IPV4_OPTIONHeader:setCOPYFLAG(int)
	int = int or 0
	self.copyFlag = hton(int)
end


function IPV4_OPTIONHeader:getOPTCLASS()
	return hton(self.optClass)
end

function IPV4_OPTIONHeader:getOPTCLASSstring()
	return self:getOPTCLASS()
end

function IPV4_OPTIONHeader:setOPTCLASS(int)
	int = int or 0
	self.optClass = hton(int)
end


function IPV4_OPTIONHeader:getOPTION()
	return hton(self.option)
end

function IPV4_OPTIONHeader:getOPTIONstring()
	return self:getOPTION()
end

function IPV4_OPTIONHeader:setOPTION(int)
	int = int or 0
	self.option = hton(int)
end


function IPV4_OPTIONHeader:getOPTIONLENGTH()
	return hton(self.optionLength)
end

function IPV4_OPTIONHeader:getOPTIONLENGTHstring()
	return self:getOPTIONLENGTH()
end

function IPV4_OPTIONHeader:setOPTIONLENGTH(int)
	int = int or 0
	self.optionLength = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTIONHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION'

	self:setCOPYFLAG(args[pre .. 'COPYFLAG'])
	self:setOPTCLASS(args[pre .. 'OPTCLASS'])
	self:setOPTION(args[pre .. 'OPTION'])
	self:setOPTIONLENGTH(args[pre .. 'OPTIONLENGTH'])
end

-- Retrieve the values of all members
function IPV4_OPTIONHeader:get(pre)
	pre = pre or 'IPV4_OPTION'

	local args = {}
	args[pre .. 'COPYFLAG'] = self:getCOPYFLAG()
	args[pre .. 'OPTCLASS'] = self:getOPTCLASS()
	args[pre .. 'OPTION'] = self:getOPTION()
	args[pre .. 'OPTIONLENGTH'] = self:getOPTIONLENGTH()

	return args
end

function IPV4_OPTIONHeader:getString()
	return 'IPV4_OPTION \n'
		.. 'COPYFLAG' .. self:getCOPYFLAGString() .. '\n'
		.. 'OPTCLASS' .. self:getOPTCLASSString() .. '\n'
		.. 'OPTION' .. self:getOPTIONString() .. '\n'
		.. 'OPTIONLENGTH' .. self:getOPTIONLENGTHString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	mri = 0x1f,
}
function IPV4_OPTIONHeader:resolveNextHeader()
	local key = self:getOPTION()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4_OPTION.metatype = IPV4_OPTIONHeader

return IPV4_OPTION