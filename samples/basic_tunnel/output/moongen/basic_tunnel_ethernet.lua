--Template for addition of new protocol 'ethernet'

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
---- ETHERNET header and constants 
-----------------------------------------------------
local ETHERNET = {}

ETHERNET.headerFormat = [[
	union bitfield_48 	 dstAddr;
	union bitfield_48 	 srcAddr;
	uint16_t 	 etherType;
]]


-- variable length fields
ETHERNET.headerVariableMember = nil

-- Module for ETHERNET_address struct
local ETHERNETHeader = initHeader()
ETHERNETHeader.__index = ETHERNETHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function ETHERNETHeader:getDSTADDR()
	return (self.dstAddr:get())
end

function ETHERNETHeader:getDSTADDRstring()
	return self:getDSTADDR()
end

function ETHERNETHeader:setDSTADDR(int)
	int = int or 0
	self.dstAddr:set(int)
end


function ETHERNETHeader:getSRCADDR()
	return (self.srcAddr:get())
end

function ETHERNETHeader:getSRCADDRstring()
	return self:getSRCADDR()
end

function ETHERNETHeader:setSRCADDR(int)
	int = int or 0
	self.srcAddr:set(int)
end


function ETHERNETHeader:getETHERTYPE()
	return hton16(self.etherType)
end

function ETHERNETHeader:getETHERTYPEstring()
	return self:getETHERTYPE()
end

function ETHERNETHeader:setETHERTYPE(int)
	int = int or 0
	self.etherType = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function ETHERNETHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'ETHERNET'

	self:setDSTADDR(args[pre .. 'DSTADDR'])
	self:setSRCADDR(args[pre .. 'SRCADDR'])
	self:setETHERTYPE(args[pre .. 'ETHERTYPE'])
end

-- Retrieve the values of all members
function ETHERNETHeader:get(pre)
	pre = pre or 'ETHERNET'

	local args = {}
	args[pre .. 'DSTADDR'] = self:getDSTADDR()
	args[pre .. 'SRCADDR'] = self:getSRCADDR()
	args[pre .. 'ETHERTYPE'] = self:getETHERTYPE()

	return args
end

function ETHERNETHeader:getString()
	return 'ETHERNET \n'
		.. 'DSTADDR' .. self:getDSTADDRString() .. '\n'
		.. 'SRCADDR' .. self:getSRCADDRString() .. '\n'
		.. 'ETHERTYPE' .. self:getETHERTYPEString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	myTunnel = 0x1212,
	ipv4 = 0x0800,
}
function ETHERNETHeader:resolveNextHeader()
	local key = self:getETHERTYPE()
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
ffi.metatype('union bitfield_48',bitfield48)ETHERNET.metatype = ETHERNETHeader

return ETHERNET