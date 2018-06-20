--Template for addition of new protocol 'myTunnel'

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
---- MYTUNNEL header and constants 
-----------------------------------------------------
local MYTUNNEL = {}

MYTUNNEL.headerFormat = [[
	uint16_t 	 proto_id;
	uint16_t 	 dst_id;
]]


-- variable length fields
MYTUNNEL.headerVariableMember = nil

-- Module for MYTUNNEL_address struct
local MYTUNNELHeader = initHeader()
MYTUNNELHeader.__index = MYTUNNELHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function MYTUNNELHeader:getPROTO_ID()
	return hton16(self.proto_id)
end

function MYTUNNELHeader:getPROTO_IDstring()
	return self:getPROTO_ID()
end

function MYTUNNELHeader:setPROTO_ID(int)
	int = int or 0
	self.proto_id = hton16(int)
end


function MYTUNNELHeader:getDST_ID()
	return hton16(self.dst_id)
end

function MYTUNNELHeader:getDST_IDstring()
	return self:getDST_ID()
end

function MYTUNNELHeader:setDST_ID(int)
	int = int or 0
	self.dst_id = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function MYTUNNELHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'MYTUNNEL'

	self:setPROTO_ID(args[pre .. 'PROTO_ID'])
	self:setDST_ID(args[pre .. 'DST_ID'])
end

-- Retrieve the values of all members
function MYTUNNELHeader:get(pre)
	pre = pre or 'MYTUNNEL'

	local args = {}
	args[pre .. 'PROTO_ID'] = self:getPROTO_ID()
	args[pre .. 'DST_ID'] = self:getDST_ID()

	return args
end

function MYTUNNELHeader:getString()
	return 'MYTUNNEL \n'
		.. 'PROTO_ID' .. self:getPROTO_IDString() .. '\n'
		.. 'DST_ID' .. self:getDST_IDString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	ipv4 = 0x0800,
}
function MYTUNNELHeader:resolveNextHeader()
	local key = self:getPROTO_ID()
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
ffi.metatype('union bitfield_48',bitfield48)MYTUNNEL.metatype = MYTUNNELHeader

return MYTUNNEL