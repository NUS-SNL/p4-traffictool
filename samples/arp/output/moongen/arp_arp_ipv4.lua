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
---- ARP_IPV4 header and constants 
-----------------------------------------------------
local ARP_IPV4 = {}

ARP_IPV4.headerFormat = [[
	union bitfield_48 	 sha;
	uint32_t 	 spa;
	union bitfield_48 	 tha;
	uint32_t 	 tpa;
]]


-- variable length fields
ARP_IPV4.headerVariableMember = nil

-- Module for ARP_IPV4_address struct
local ARP_IPV4Header = initHeader()
ARP_IPV4Header.__index = ARP_IPV4Header


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ARP_IPV4Header:getSHA()
	return (self.sha:get())
end

function ARP_IPV4Header:getSHAstring()
	return self:getSHA()
end

function ARP_IPV4Header:setSHA(int)
	int = int or 0
	self.sha:set(int)
end


function ARP_IPV4Header:getSPA()
	return hton(self.spa)
end

function ARP_IPV4Header:getSPAstring()
	return self:getSPA()
end

function ARP_IPV4Header:setSPA(int)
	int = int or 0
	self.spa = hton(int)
end


function ARP_IPV4Header:getTHA()
	return (self.tha:get())
end

function ARP_IPV4Header:getTHAstring()
	return self:getTHA()
end

function ARP_IPV4Header:setTHA(int)
	int = int or 0
	self.tha:set(int)
end


function ARP_IPV4Header:getTPA()
	return hton(self.tpa)
end

function ARP_IPV4Header:getTPAstring()
	return self:getTPA()
end

function ARP_IPV4Header:setTPA(int)
	int = int or 0
	self.tpa = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ARP_IPV4Header:fill(args,pre)
	args = args or {}
	pre = pre or 'ARP_IPV4'

	self:setSHA(args[pre .. 'SHA'])
	self:setSPA(args[pre .. 'SPA'])
	self:setTHA(args[pre .. 'THA'])
	self:setTPA(args[pre .. 'TPA'])
end

-- Retrieve the values of all members
function ARP_IPV4Header:get(pre)
	pre = pre or 'ARP_IPV4'

	local args = {}
	args[pre .. 'SHA'] = self:getSHA()
	args[pre .. 'SPA'] = self:getSPA()
	args[pre .. 'THA'] = self:getTHA()
	args[pre .. 'TPA'] = self:getTPA()

	return args
end

function ARP_IPV4Header:getString()
	return 'ARP_IPV4 \n'
		.. 'SHA' .. self:getSHAString() .. '\n'
		.. 'SPA' .. self:getSPAString() .. '\n'
		.. 'THA' .. self:getTHAString() .. '\n'
		.. 'TPA' .. self:getTPAString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function ARP_IPV4Header:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)ARP_IPV4.metatype = ARP_IPV4Header

return ARP_IPV4