--Template for addition of new protocol 'ipv4_option_security'

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
---- IPV4_OPTION_SECURITY header and constants 
-----------------------------------------------------
local IPV4_OPTION_SECURITY = {}

IPV4_OPTION_SECURITY.headerFormat = [[
	8 	 value;
	8 	 len;
	72 	 security;
]]


-- variable length fields
IPV4_OPTION_SECURITY.headerVariableMember = nil

-- Module for IPV4_OPTION_SECURITY_address struct
local IPV4_OPTION_SECURITYHeader = initHeader()
IPV4_OPTION_SECURITYHeader.__index = IPV4_OPTION_SECURITYHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTION_SECURITYHeader:getVALUE()
	return hton(self.value)
end

function IPV4_OPTION_SECURITYHeader:getVALUEstring()
	return self:getVALUE()
end

function IPV4_OPTION_SECURITYHeader:setVALUE(int)
	int = int or 0
	self.value = hton(int)
end


function IPV4_OPTION_SECURITYHeader:getLEN()
	return hton(self.len)
end

function IPV4_OPTION_SECURITYHeader:getLENstring()
	return self:getLEN()
end

function IPV4_OPTION_SECURITYHeader:setLEN(int)
	int = int or 0
	self.len = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTION_SECURITYHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION_SECURITY'

	self:setVALUE(args[pre .. 'VALUE'])
	self:setLEN(args[pre .. 'LEN'])
	self:setSECURITY(args[pre .. 'SECURITY'])
end

-- Retrieve the values of all members
function IPV4_OPTION_SECURITYHeader:get(pre)
	pre = pre or 'IPV4_OPTION_SECURITY'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()
	args[pre .. 'LEN'] = self:getLEN()
	args[pre .. 'SECURITY'] = self:getSECURITY()

	return args
end

function IPV4_OPTION_SECURITYHeader:getString()
	return 'IPV4_OPTION_SECURITY \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
		.. 'LEN' .. self:getLENString() .. '\n'
		.. 'SECURITY' .. self:getSECURITYString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function IPV4_OPTION_SECURITYHeader:resolveNextHeader()
	 return parse_ipv4_options
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4_OPTION_SECURITY.metatype = IPV4_OPTION_SECURITYHeader

return IPV4_OPTION_SECURITY