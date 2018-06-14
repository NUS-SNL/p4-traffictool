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
local bor, band, bnot, rshift, lshift= bit.bor, bit.band, bit.bnot, bit.rshift, bit.lshift
local istype = ffi.istype
local format = string.format

-----------------------------------------------------
---- MYTUNNEL header and constants 
-----------------------------------------------------
local MYTUNNEL = {}

MYTUNNEL.headerFormat = [[
	16 	 proto_id;
	16 	 dst_id;
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
	return hton(self.proto_id)
end

function MYTUNNELHeader:getPROTO_IDstring()
	return self:getPROTO_ID()
end

function MYTUNNELHeader:setPROTO_ID(int)
	int = int or 0
	self.proto_id = hton(int)
end


function MYTUNNELHeader:getDST_ID()
	return hton(self.dst_id)
end

function MYTUNNELHeader:getDST_IDstring()
	return self:getDST_ID()
end

function MYTUNNELHeader:setDST_ID(int)
	int = int or 0
	self.dst_id = hton(int)
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
MYTUNNEL.metatype = MYTUNNELHeader

return MYTUNNEL