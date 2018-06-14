--Template for addition of new protocol 'srcRoutes'

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
---- SRCROUTES header and constants 
-----------------------------------------------------
local SRCROUTES = {}

SRCROUTES.headerFormat = [[
	1 	 bos;
	15 	 port;
]]


-- variable length fields
SRCROUTES.headerVariableMember = nil

-- Module for SRCROUTES_address struct
local SRCROUTESHeader = initHeader()
SRCROUTESHeader.__index = SRCROUTESHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function SRCROUTESHeader:getBOS()
	return hton(self.bos)
end

function SRCROUTESHeader:getBOSstring()
	return self:getBOS()
end

function SRCROUTESHeader:setBOS(int)
	int = int or 0
	self.bos = hton(int)
end


function SRCROUTESHeader:getPORT()
	return hton(self.port)
end

function SRCROUTESHeader:getPORTstring()
	return self:getPORT()
end

function SRCROUTESHeader:setPORT(int)
	int = int or 0
	self.port = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function SRCROUTESHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'SRCROUTES'

	self:setBOS(args[pre .. 'BOS'])
	self:setPORT(args[pre .. 'PORT'])
end

-- Retrieve the values of all members
function SRCROUTESHeader:get(pre)
	pre = pre or 'SRCROUTES'

	local args = {}
	args[pre .. 'BOS'] = self:getBOS()
	args[pre .. 'PORT'] = self:getPORT()

	return args
end

function SRCROUTESHeader:getString()
	return 'SRCROUTES \n'
		.. 'BOS' .. self:getBOSString() .. '\n'
		.. 'PORT' .. self:getPORTString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
	ipv4 = 0x01,
	srcRoutes = default,
}
function SRCROUTESHeader:resolveNextHeader()
	local key = self:getBOS()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
SRCROUTES.metatype = SRCROUTESHeader

return SRCROUTES