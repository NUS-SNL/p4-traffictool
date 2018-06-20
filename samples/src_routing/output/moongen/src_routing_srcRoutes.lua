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
local ntoh64, hton64 = ntoh64, hton64
local bor, band, bnot, rshift, lshift= bit.bor, bit.band, bit.bnot, bit.rshift, bit.lshift
local istype = ffi.istype
local format = string.format

----- 24 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_24{
		uint32_t intequiv;
	};
]]

local bitfield24 = {}
bitfield24.__index = bitfield24
local bitfield24Type = ffi.typeof("union bitfield_24")

function bitfield24:get()
	return hton32(self.intequiv)
end

function bitfield24:set(addr)
	addr = addr or 0
	self.intequiv = hton32(tonumber(band(addr,0xFFFFFFFFULL)))

end

----- 40 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_24{
		uint64_t intequiv;
	};
]]

local bitfield40 = {}
bitfield40.__index = bitfield40
local bitfield40Type = ffi.typeof("union bitfield_40")

function bitfield40:get()
	return hton64(self.intequiv)
end

function bitfield40:set(addr)
	addr = addr or 0
	self.intequiv = hton64(tonumber(band(addr,0xFFFFFFFFFFFFFFFFULL)))
end

----- 48 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_48{
		uint32_t intequiv;
	};
]]

local bitfield48 = {}
bitfield48.__index = bitfield48
local bitfield48Type = ffi.typeof("union bitfield_48")

function bitfield48:get()
	return hton64(self.intequiv)
end

function bitfield48:set(addr)
	addr = addr or 0
	self.intequiv = hton64(tonumber(band(addr,0xFFFFFFFFFFFFFFFFULL)))
end


-----------------------------------------------------
---- SRCROUTES header and constants 
-----------------------------------------------------
local SRCROUTES = {}

SRCROUTES.headerFormat = [[
	uint8_t 	 bos;
	uint16_t 	 port;
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
	return (self.bos)
end

function SRCROUTESHeader:getBOSstring()
	return self:getBOS()
end

function SRCROUTESHeader:setBOS(int)
	int = int or 0
	self.bos = (int)
end


function SRCROUTESHeader:getPORT()
	return hton16(self.port:get())
end

function SRCROUTESHeader:getPORTstring()
	return self:getPORT()
end

function SRCROUTESHeader:setPORT(int)
	int = int or 0
	self.port:sethton16(int)
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
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)SRCROUTES.metatype = SRCROUTESHeader

return SRCROUTES