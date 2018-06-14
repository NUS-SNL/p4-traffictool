--Template for addition of new protocol 'swids'

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
---- SWIDS header and constants 
-----------------------------------------------------
local SWIDS = {}

SWIDS.headerFormat = [[
	32 	 swid;
]]


-- variable length fields
SWIDS.headerVariableMember = nil

-- Module for SWIDS_address struct
local SWIDSHeader = initHeader()
SWIDSHeader.__index = SWIDSHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function SWIDSHeader:getSWID()
	return hton(self.swid)
end

function SWIDSHeader:getSWIDstring()
	return self:getSWID()
end

function SWIDSHeader:setSWID(int)
	int = int or 0
	self.swid = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function SWIDSHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'SWIDS'

	self:setSWID(args[pre .. 'SWID'])
end

-- Retrieve the values of all members
function SWIDSHeader:get(pre)
	pre = pre or 'SWIDS'

	local args = {}
	args[pre .. 'SWID'] = self:getSWID()

	return args
end

function SWIDSHeader:getString()
	return 'SWIDS \n'
		.. 'SWID' .. self:getSWIDString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	swids = default,
}
function SWIDSHeader:resolveNextHeader()
	local key = self:getREMAINING()
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
SWIDS.metatype = SWIDSHeader

return SWIDS