--Template for addition of new protocol 'arp_ipv4'

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
	return hton(self.intequiv)
end

function bitfield24:set(addr)
	addr = addr or 0
	self.intequiv = hton(tonumber(band(addr,0xFFFFFFFFULL)))

end

----- 40 bit address -----
ffi.cdef[[
	union __attribute__((__packed__)) bitfield_40{
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
---- arp_ipv4 header and constants 
-----------------------------------------------------
local arp_ipv4 = {}

arp_ipv4.headerFormat = [[
	union bitfield_48 	 sha;
	uint32_t 	 spa;
	union bitfield_48 	 tha;
	uint32_t 	 tpa;
]]


-- variable length fields
arp_ipv4.headerVariableMember = nil

-- Module for arp_ipv4_address struct
local arp_ipv4Header = initHeader()
arp_ipv4Header.__index = arp_ipv4Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function arp_ipv4Header:getSHA()
	return (self.sha:get())
end

function arp_ipv4Header:getSHAstring()
	return self:getSHA()
end

function arp_ipv4Header:setSHA(int)
	int = int or 0
	self.sha:set(int)
end


function arp_ipv4Header:getSPA()
	return hton(self.spa)
end

function arp_ipv4Header:getSPAstring()
	return self:getSPA()
end

function arp_ipv4Header:setSPA(int)
	int = int or 0
	self.spa = hton(int)
end


function arp_ipv4Header:getTHA()
	return (self.tha:get())
end

function arp_ipv4Header:getTHAstring()
	return self:getTHA()
end

function arp_ipv4Header:setTHA(int)
	int = int or 0
	self.tha:set(int)
end


function arp_ipv4Header:getTPA()
	return hton(self.tpa)
end

function arp_ipv4Header:getTPAstring()
	return self:getTPA()
end

function arp_ipv4Header:setTPA(int)
	int = int or 0
	self.tpa = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function arp_ipv4Header:fill(args,pre)
	args = args or {}
	pre = pre or 'arp_ipv4'

	self:setSHA(args[pre .. 'SHA'])
	self:setSPA(args[pre .. 'SPA'])
	self:setTHA(args[pre .. 'THA'])
	self:setTPA(args[pre .. 'TPA'])
end

-- Retrieve the values of all members
function arp_ipv4Header:get(pre)
	pre = pre or 'arp_ipv4'

	local args = {}
	args[pre .. 'SHA'] = self:getSHA()
	args[pre .. 'SPA'] = self:getSPA()
	args[pre .. 'THA'] = self:getTHA()
	args[pre .. 'TPA'] = self:getTPA()

	return args
end

function arp_ipv4Header:getString()
	return 'arp_ipv4 \n'
		.. 'SHA' .. self:getSHAString() .. '\n'
		.. 'SPA' .. self:getSPAString() .. '\n'
		.. 'THA' .. self:getTHAString() .. '\n'
		.. 'TPA' .. self:getTPAString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function arp_ipv4Header:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)
arp_ipv4.metatype = arp_ipv4Header

return arp_ipv4