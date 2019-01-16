--Template for addition of new protocol 'myTunnel'

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
---- basic_tunnel_mytunnel header and constants 
-----------------------------------------------------
local basic_tunnel_mytunnel = {}

basic_tunnel_mytunnel.headerFormat = [[
	uint16_t 	 proto_id;
	uint16_t 	 dst_id;
]]


-- variable length fields
basic_tunnel_mytunnel.headerVariableMember = nil

-- Module for basic_tunnel_mytunnel_address struct
local basic_tunnel_mytunnelHeader = initHeader()
basic_tunnel_mytunnelHeader.__index = basic_tunnel_mytunnelHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function basic_tunnel_mytunnelHeader:getPROTO_ID()
	return hton16(self.proto_id)
end

function basic_tunnel_mytunnelHeader:getPROTO_IDstring()
	return self:getPROTO_ID()
end

function basic_tunnel_mytunnelHeader:setPROTO_ID(int)
	int = int or 0
	self.proto_id = hton16(int)
end


function basic_tunnel_mytunnelHeader:getDST_ID()
	return hton16(self.dst_id)
end

function basic_tunnel_mytunnelHeader:getDST_IDstring()
	return self:getDST_ID()
end

function basic_tunnel_mytunnelHeader:setDST_ID(int)
	int = int or 0
	self.dst_id = hton16(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function basic_tunnel_mytunnelHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'basic_tunnel_mytunnel'

	self:setPROTO_ID(args[pre .. 'PROTO_ID'])
	self:setDST_ID(args[pre .. 'DST_ID'])
end

-- Retrieve the values of all members
function basic_tunnel_mytunnelHeader:get(pre)
	pre = pre or 'basic_tunnel_mytunnel'

	local args = {}
	args[pre .. 'PROTO_ID'] = self:getPROTO_ID()
	args[pre .. 'DST_ID'] = self:getDST_ID()

	return args
end

function basic_tunnel_mytunnelHeader:getString()
	return 'basic_tunnel_mytunnel \n'
		.. 'PROTO_ID' .. self:getPROTO_IDString() .. '\n'
		.. 'DST_ID' .. self:getDST_IDString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
	basic_tunnel_ipv4 = 0x0800,
}
function basic_tunnel_mytunnelHeader:resolveNextHeader()
	local key = self:getPROTO_ID()
	for name, value in pairs(nextHeaderResolve) do
		if key == value then
			return name
		end
	end
	return nil
end

function basic_tunnel_mytunnelHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	if not namedArgs[pre .. 'PROTO_ID'] then
		for name, _port in pairs(nextHeaderResolve) do
			if nextHeader == name then
				namedArgs[pre .. 'PROTO_ID'] = _port
				break
			end
		end
	end
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
basic_tunnel_mytunnel.metatype = basic_tunnel_mytunnelHeader

return basic_tunnel_mytunnel