--Template for addition of new protocol 'ipv4_option_EOL'

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
---- IPV4_OPTION_EOL header and constants 
-----------------------------------------------------
local IPV4_OPTION_EOL = {}

IPV4_OPTION_EOL.headerFormat = [[
	8 	 value;
]]


-- variable length fields
IPV4_OPTION_EOL.headerVariableMember = nil

-- Module for IPV4_OPTION_EOL_address struct
local IPV4_OPTION_EOLHeader = initHeader()
IPV4_OPTION_EOLHeader.__index = IPV4_OPTION_EOLHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function IPV4_OPTION_EOLHeader:getVALUE()
	return hton(self.value)
end

function IPV4_OPTION_EOLHeader:getVALUEstring()
	return self:getVALUE()
end

function IPV4_OPTION_EOLHeader:setVALUE(int)
	int = int or 0
	self.value = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function IPV4_OPTION_EOLHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'IPV4_OPTION_EOL'

	self:setVALUE(args[pre .. 'VALUE'])
end

-- Retrieve the values of all members
function IPV4_OPTION_EOLHeader:get(pre)
	pre = pre or 'IPV4_OPTION_EOL'

	local args = {}
	args[pre .. 'VALUE'] = self:getVALUE()

	return args
end

function IPV4_OPTION_EOLHeader:getString()
	return 'IPV4_OPTION_EOL \n'
		.. 'VALUE' .. self:getVALUEString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function IPV4_OPTION_EOLHeader:resolveNextHeader()
	 return parse_ipv4_options
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
IPV4_OPTION_EOL.metatype = IPV4_OPTION_EOLHeader

return IPV4_OPTION_EOL