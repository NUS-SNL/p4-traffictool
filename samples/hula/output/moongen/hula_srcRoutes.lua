--Template for addition of new protocol 'srcRoutes'

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
---- hula_srcroutes header and constants 
-----------------------------------------------------
local hula_srcroutes = {}

hula_srcroutes.headerFormat = [[
	uint8_t 	 bos;
	uint16_t 	 port;
]]


-- variable length fields
hula_srcroutes.headerVariableMember = nil

-- Module for hula_srcroutes_address struct
local hula_srcroutesHeader = initHeader()
hula_srcroutesHeader.__index = hula_srcroutesHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function hula_srcroutesHeader:getBOS()
	return (self.bos)
end

function hula_srcroutesHeader:getBOSstring()
	return self:getBOS()
end

function hula_srcroutesHeader:setBOS(int)
	int = int or 0
	self.bos = (int)
end


function hula_srcroutesHeader:getPORT()
	return hton16(self.port)
end

function hula_srcroutesHeader:getPORTstring()
	return self:getPORT()
end

function hula_srcroutesHeader:setPORT(int)
	int = int or 0
	self.port = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function hula_srcroutesHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'hula_srcroutes'

	self:setBOS(args[pre .. 'BOS'])
	self:setPORT(args[pre .. 'PORT'])
end

-- Retrieve the values of all members
function hula_srcroutesHeader:get(pre)
	pre = pre or 'hula_srcroutes'

	local args = {}
	args[pre .. 'BOS'] = self:getBOS()
	args[pre .. 'PORT'] = self:getPORT()

	return args
end

function hula_srcroutesHeader:getString()
	return 'hula_srcroutes \n'
		.. 'BOS' .. self:getBOSString() .. '\n'
		.. 'PORT' .. self:getPORTString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	hula_ipv4 = 0x01,
	hula_srcroutes = default,
}
function hula_srcroutesHeader:resolveNextHeader()
	local key = self:getBOS()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function hula_srcroutesHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'BOS'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'BOS'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
hula_srcroutes.metatype = hula_srcroutesHeader

return hula_srcroutes