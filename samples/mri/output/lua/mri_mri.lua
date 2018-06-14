--Template for addition of new protocol 'mri'

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
---- MRI header and constants 
-----------------------------------------------------
local MRI = {}

MRI.headerFormat = [[
	16 	 count;
]]


-- variable length fields
MRI.headerVariableMember = nil

-- Module for MRI_address struct
local MRIHeader = initHeader()
MRIHeader.__index = MRIHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function MRIHeader:getCOUNT()
	return hton(self.count)
end

function MRIHeader:getCOUNTstring()
	return self:getCOUNT()
end

function MRIHeader:setCOUNT(int)
	int = int or 0
	self.count = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function MRIHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'MRI'

	self:setCOUNT(args[pre .. 'COUNT'])
end

-- Retrieve the values of all members
function MRIHeader:get(pre)
	pre = pre or 'MRI'

	local args = {}
	args[pre .. 'COUNT'] = self:getCOUNT()

	return args
end

function MRIHeader:getString()
	return 'MRI \n'
		.. 'COUNT' .. self:getCOUNTString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	swids = default,
}
function MRIHeader:resolveNextHeader()
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
MRI.metatype = MRIHeader

return MRI