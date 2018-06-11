--Template for addition of new protocol 'ipv4_option_NOP'

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
---- IPV4_OPTION_NOP header and constants 
-----------------------------------------------------
local IPV4_OPTION_NOP = {}

IPV4_OPTION_NOP.headerFormat = [[
	8 	 value;
]]


-- variable length fields
IPV4_OPTION_NOP.headerVariableMember = nil

-- Module for IPV4_OPTION_NOP_address struct
local IPV4_OPTION_NOPHeader = initHeader()
IPV4_OPTION_NOPHeader.__index = IPV4_OPTION_NOPHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------

-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTION_NOPHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION_NOP'

	self:setVALUE(args[pre .. 'VALUE'])
end

-- Retrieve the values of all members
function IPV4_OPTION_NOPHeader:get(pre)
	pre = pre or 'IPV4_OPTION_NOP'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()

	return args
end

function IPV4_OPTION_NOPHeader:getString()
	return 'IPV4_OPTION_NOP \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function IPV4_OPTION_NOPHeader:resolveNextHeader()
	 return parse_ipv4_options
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4_OPTION_NOP.metatype = IPV4_OPTION_NOPHeader

return IPV4_OPTION_NOP