--Template for addition of new protocol 'snapshot'

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
---- SNAPSHOT header and constants 
-----------------------------------------------------
local SNAPSHOT = {}

SNAPSHOT.headerFormat = [[
	16 	 ingress_global_tstamp_hi_16;
	32 	 ingress_global_tstamp_lo_32;
	32 	 egress_global_tstamp_lo_32;
	32 	 enq_qdepth;
	32 	 deq_qdepth;
	16 	 _pad0;
	48 	 orig_egress_global_tstamp;
	16 	 _pad1;
	48 	 new_egress_global_tstamp;
	32 	 new_enq_tstamp;
]]


-- variable length fields
SNAPSHOT.headerVariableMember = nil

-- Module for SNAPSHOT_address struct
local SNAPSHOTHeader = initHeader()
SNAPSHOTHeader.__index = SNAPSHOTHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function SNAPSHOTHeader:getINGRESS_GLOBAL_TSTAMP_HI_16()
	return hton(self.ingress_global_tstamp_hi_16)
end

function SNAPSHOTHeader:getINGRESS_GLOBAL_TSTAMP_HI_16string()
	return self:getINGRESS_GLOBAL_TSTAMP_HI_16()
end

function SNAPSHOTHeader:setINGRESS_GLOBAL_TSTAMP_HI_16(int)
	int = int or 0
	self.ingress_global_tstamp_hi_16 = hton(int)
end


function SNAPSHOTHeader:getINGRESS_GLOBAL_TSTAMP_LO_32()
	return hton(self.ingress_global_tstamp_lo_32)
end

function SNAPSHOTHeader:getINGRESS_GLOBAL_TSTAMP_LO_32string()
	return self:getINGRESS_GLOBAL_TSTAMP_LO_32()
end

function SNAPSHOTHeader:setINGRESS_GLOBAL_TSTAMP_LO_32(int)
	int = int or 0
	self.ingress_global_tstamp_lo_32 = hton(int)
end


function SNAPSHOTHeader:getEGRESS_GLOBAL_TSTAMP_LO_32()
	return hton(self.egress_global_tstamp_lo_32)
end

function SNAPSHOTHeader:getEGRESS_GLOBAL_TSTAMP_LO_32string()
	return self:getEGRESS_GLOBAL_TSTAMP_LO_32()
end

function SNAPSHOTHeader:setEGRESS_GLOBAL_TSTAMP_LO_32(int)
	int = int or 0
	self.egress_global_tstamp_lo_32 = hton(int)
end


function SNAPSHOTHeader:getENQ_QDEPTH()
	return hton(self.enq_qdepth)
end

function SNAPSHOTHeader:getENQ_QDEPTHstring()
	return self:getENQ_QDEPTH()
end

function SNAPSHOTHeader:setENQ_QDEPTH(int)
	int = int or 0
	self.enq_qdepth = hton(int)
end


function SNAPSHOTHeader:getDEQ_QDEPTH()
	return hton(self.deq_qdepth)
end

function SNAPSHOTHeader:getDEQ_QDEPTHstring()
	return self:getDEQ_QDEPTH()
end

function SNAPSHOTHeader:setDEQ_QDEPTH(int)
	int = int or 0
	self.deq_qdepth = hton(int)
end


function SNAPSHOTHeader:get_PAD0()
	return hton(self._pad0)
end

function SNAPSHOTHeader:get_PAD0string()
	return self:get_PAD0()
end

function SNAPSHOTHeader:set_PAD0(int)
	int = int or 0
	self._pad0 = hton(int)
end


function SNAPSHOTHeader:getORIG_EGRESS_GLOBAL_TSTAMP()
	return hton(self.orig_egress_global_tstamp)
end

function SNAPSHOTHeader:getORIG_EGRESS_GLOBAL_TSTAMPstring()
	return self:getORIG_EGRESS_GLOBAL_TSTAMP()
end

function SNAPSHOTHeader:setORIG_EGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.orig_egress_global_tstamp = hton(int)
end


function SNAPSHOTHeader:get_PAD1()
	return hton(self._pad1)
end

function SNAPSHOTHeader:get_PAD1string()
	return self:get_PAD1()
end

function SNAPSHOTHeader:set_PAD1(int)
	int = int or 0
	self._pad1 = hton(int)
end


function SNAPSHOTHeader:getNEW_EGRESS_GLOBAL_TSTAMP()
	return hton(self.new_egress_global_tstamp)
end

function SNAPSHOTHeader:getNEW_EGRESS_GLOBAL_TSTAMPstring()
	return self:getNEW_EGRESS_GLOBAL_TSTAMP()
end

function SNAPSHOTHeader:setNEW_EGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.new_egress_global_tstamp = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function SNAPSHOTHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'SNAPSHOT'

	self:setINGRESS_GLOBAL_TSTAMP_HI_16(args[pre .. 'INGRESS_GLOBAL_TSTAMP_HI_16'])
	self:setINGRESS_GLOBAL_TSTAMP_LO_32(args[pre .. 'INGRESS_GLOBAL_TSTAMP_LO_32'])
	self:setEGRESS_GLOBAL_TSTAMP_LO_32(args[pre .. 'EGRESS_GLOBAL_TSTAMP_LO_32'])
	self:setENQ_QDEPTH(args[pre .. 'ENQ_QDEPTH'])
	self:setDEQ_QDEPTH(args[pre .. 'DEQ_QDEPTH'])
	self:set_PAD0(args[pre .. '_PAD0'])
	self:setORIG_EGRESS_GLOBAL_TSTAMP(args[pre .. 'ORIG_EGRESS_GLOBAL_TSTAMP'])
	self:set_PAD1(args[pre .. '_PAD1'])
	self:setNEW_EGRESS_GLOBAL_TSTAMP(args[pre .. 'NEW_EGRESS_GLOBAL_TSTAMP'])
	self:setNEW_ENQ_TSTAMP(args[pre .. 'NEW_ENQ_TSTAMP'])
end

-- Retrieve the values of all members
function SNAPSHOTHeader:get(pre)
	pre = pre or 'SNAPSHOT'

	local args = {}
	args[pre .. 'INGRESS_GLOBAL_TSTAMP_HI_16'] = self:getINGRESS_GLOBAL_TSTAMP_HI_16()
	args[pre .. 'INGRESS_GLOBAL_TSTAMP_LO_32'] = self:getINGRESS_GLOBAL_TSTAMP_LO_32()
	args[pre .. 'EGRESS_GLOBAL_TSTAMP_LO_32'] = self:getEGRESS_GLOBAL_TSTAMP_LO_32()
	args[pre .. 'ENQ_QDEPTH'] = self:getENQ_QDEPTH()
	args[pre .. 'DEQ_QDEPTH'] = self:getDEQ_QDEPTH()
	args[pre .. '_PAD0'] = self:get_PAD0()
	args[pre .. 'ORIG_EGRESS_GLOBAL_TSTAMP'] = self:getORIG_EGRESS_GLOBAL_TSTAMP()
	args[pre .. '_PAD1'] = self:get_PAD1()
	args[pre .. 'NEW_EGRESS_GLOBAL_TSTAMP'] = self:getNEW_EGRESS_GLOBAL_TSTAMP()
	args[pre .. 'NEW_ENQ_TSTAMP'] = self:getNEW_ENQ_TSTAMP()

	return args
end

function SNAPSHOTHeader:getString()
	return 'SNAPSHOT \n'
		.. 'INGRESS_GLOBAL_TSTAMP_HI_16' .. self:getINGRESS_GLOBAL_TSTAMP_HI_16String() .. '\n'
		.. 'INGRESS_GLOBAL_TSTAMP_LO_32' .. self:getINGRESS_GLOBAL_TSTAMP_LO_32String() .. '\n'
		.. 'EGRESS_GLOBAL_TSTAMP_LO_32' .. self:getEGRESS_GLOBAL_TSTAMP_LO_32String() .. '\n'
		.. 'ENQ_QDEPTH' .. self:getENQ_QDEPTHString() .. '\n'
		.. 'DEQ_QDEPTH' .. self:getDEQ_QDEPTHString() .. '\n'
		.. '_PAD0' .. self:get_PAD0String() .. '\n'
		.. 'ORIG_EGRESS_GLOBAL_TSTAMP' .. self:getORIG_EGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. '_PAD1' .. self:get_PAD1String() .. '\n'
		.. 'NEW_EGRESS_GLOBAL_TSTAMP' .. self:getNEW_EGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. 'NEW_ENQ_TSTAMP' .. self:getNEW_ENQ_TSTAMPString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function SNAPSHOTHeader:resolveNextHeader()
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
SNAPSHOT.metatype = SNAPSHOTHeader

return SNAPSHOT