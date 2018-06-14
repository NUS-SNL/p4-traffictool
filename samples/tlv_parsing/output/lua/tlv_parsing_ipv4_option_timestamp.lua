--Template for addition of new protocol 'ipv4_option_timestamp'

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
---- IPV4_OPTION_TIMESTAMP header and constants 
-----------------------------------------------------
local IPV4_OPTION_TIMESTAMP = {}

IPV4_OPTION_TIMESTAMP.headerFormat = [[
	8 	 value;
	8 	 len;
]]


-- variable length fields
IPV4_OPTION_TIMESTAMP.headerVariableMember = 'data'

-- Module for IPV4_OPTION_TIMESTAMP_address struct
local IPV4_OPTION_TIMESTAMPHeader = initHeader()
IPV4_OPTION_TIMESTAMPHeader.__index = IPV4_OPTION_TIMESTAMPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTION_TIMESTAMPHeader:getVALUE()
	return hton(self.value)
end

function IPV4_OPTION_TIMESTAMPHeader:getVALUEstring()
	return self:getVALUE()
end

function IPV4_OPTION_TIMESTAMPHeader:setVALUE(int)
	int = int or 0
	self.value = hton(int)
end


function IPV4_OPTION_TIMESTAMPHeader:getLEN()
	return hton(self.len)
end

function IPV4_OPTION_TIMESTAMPHeader:getLENstring()
	return self:getLEN()
end

function IPV4_OPTION_TIMESTAMPHeader:setLEN(int)
	int = int or 0
	self.len = hton(int)
end


function IPV4_OPTION_TIMESTAMPHeader:getDATA()
	return hton(self.data)
end

function IPV4_OPTION_TIMESTAMPHeader:getDATAstring()
	return self:getDATA()
end

function IPV4_OPTION_TIMESTAMPHeader:setDATA(int)
	int = int or 0
	self.data = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTION_TIMESTAMPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION_TIMESTAMP'

	self:setVALUE(args[pre .. 'VALUE'])
	self:setLEN(args[pre .. 'LEN'])
	self:setDATA(args[pre .. 'DATA'])
end

-- Retrieve the values of all members
function IPV4_OPTION_TIMESTAMPHeader:get(pre)
	pre = pre or 'IPV4_OPTION_TIMESTAMP'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()
	args[pre .. 'LEN'] = self:getLEN()
	args[pre .. 'DATA'] = self:getDATA()

	return args
end

function IPV4_OPTION_TIMESTAMPHeader:getString()
	return 'IPV4_OPTION_TIMESTAMP \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
		.. 'LEN' .. self:getLENString() .. '\n'
		.. 'DATA' .. self:getDATAString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function IPV4_OPTION_TIMESTAMPHeader:resolveNextHeader()
	return parse_ipv4_options
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4_OPTION_TIMESTAMP.metatype = IPV4_OPTION_TIMESTAMPHeader

return IPV4_OPTION_TIMESTAMP