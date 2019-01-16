--Template for addition of new protocol 'overlay'

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
---- netchain_overlay header and constants 
-----------------------------------------------------
local netchain_overlay = {}

netchain_overlay.headerFormat = [[
	uint32_t 	 swip;
]]


-- variable length fields
netchain_overlay.headerVariableMember = nil

-- Module for netchain_overlay_address struct
local netchain_overlayHeader = initHeader()
netchain_overlayHeader.__index = netchain_overlayHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function netchain_overlayHeader:getSWIP()
	return hton(self.swip)
end

function netchain_overlayHeader:getSWIPstring()
	return self:getSWIP()
end

function netchain_overlayHeader:setSWIP(int)
	int = int or 0
	self.swip = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function netchain_overlayHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'netchain_overlay'

	self:setSWIP(args[pre .. 'SWIP'])
end

-- Retrieve the values of all members
function netchain_overlayHeader:get(pre)
	pre = pre or 'netchain_overlay'

	local args = {}
	args[pre .. 'SWIP'] = self:getSWIP()

	return args
end

function netchain_overlayHeader:getString()
	return 'netchain_overlay \n'
		.. 'SWIP' .. self:getSWIPString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	netchain_nc_hdr = 0x00000000,
	netchain_overlay = default,
}
function netchain_overlayHeader:resolveNextHeader()
	local key = self:getSWIP()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function netchain_overlayHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'SWIP'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'SWIP'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
netchain_overlay.metatype = netchain_overlayHeader

return netchain_overlay