--Template for addition of new protocol 'cpu_header'

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
---- CPU_HEADER header and constants 
-----------------------------------------------------
local CPU_HEADER = {}

CPU_HEADER.headerFormat = [[
	64 	 preamble;
	8 	 device;
	8 	 reason;
	8 	 if_index;
]]


-- variable length fields
CPU_HEADER.headerVariableMember = nil

-- Module for CPU_HEADER_address struct
local CPU_HEADERHeader = initHeader()
CPU_HEADERHeader.__index = CPU_HEADERHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function CPU_HEADERHeader:getPREAMBLE()
	return hton(self.preamble)
end

function CPU_HEADERHeader:getPREAMBLEstring()
	return self:getPREAMBLE()
end

function CPU_HEADERHeader:setPREAMBLE(int)
	int = int or 0
	self.preamble = hton(int)
end


function CPU_HEADERHeader:getDEVICE()
	return hton(self.device)
end

function CPU_HEADERHeader:getDEVICEstring()
	return self:getDEVICE()
end

function CPU_HEADERHeader:setDEVICE(int)
	int = int or 0
	self.device = hton(int)
end


function CPU_HEADERHeader:getREASON()
	return hton(self.reason)
end

function CPU_HEADERHeader:getREASONstring()
	return self:getREASON()
end

function CPU_HEADERHeader:setREASON(int)
	int = int or 0
	self.reason = hton(int)
end


function CPU_HEADERHeader:getIF_INDEX()
	return hton(self.if_index)
end

function CPU_HEADERHeader:getIF_INDEXstring()
	return self:getIF_INDEX()
end

function CPU_HEADERHeader:setIF_INDEX(int)
	int = int or 0
	self.if_index = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function CPU_HEADERHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'CPU_HEADER'

	self:setPREAMBLE(args[pre .. 'PREAMBLE'])
	self:setDEVICE(args[pre .. 'DEVICE'])
	self:setREASON(args[pre .. 'REASON'])
	self:setIF_INDEX(args[pre .. 'IF_INDEX'])
end

-- Retrieve the values of all members
function CPU_HEADERHeader:get(pre)
	pre = pre or 'CPU_HEADER'

	local args = {}
	args[pre .. 'PREAMBLE'] = self:getPREAMBLE()
	args[pre .. 'DEVICE'] = self:getDEVICE()
	args[pre .. 'REASON'] = self:getREASON()
	args[pre .. 'IF_INDEX'] = self:getIF_INDEX()

	return args
end

function CPU_HEADERHeader:getString()
	return 'CPU_HEADER \n'
		.. 'PREAMBLE' .. self:getPREAMBLEString() .. '\n'
		.. 'DEVICE' .. self:getDEVICEString() .. '\n'
		.. 'REASON' .. self:getREASONString() .. '\n'
		.. 'IF_INDEX' .. self:getIF_INDEXString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function CPU_HEADERHeader:resolveNextHeader()
	return ethernet
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
CPU_HEADER.metatype = CPU_HEADERHeader

return CPU_HEADER