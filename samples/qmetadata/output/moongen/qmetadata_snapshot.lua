--Template for addition of new protocol 'snapshot'

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
---- qmetadata_snapshot header and constants 
-----------------------------------------------------
local qmetadata_snapshot = {}

qmetadata_snapshot.headerFormat = [[
	uint16_t 	 ingress_global_tstamp_hi_16;
	uint32_t 	 ingress_global_tstamp_lo_32;
	uint32_t 	 egress_global_tstamp_lo_32;
	uint32_t 	 enq_qdepth;
	uint32_t 	 deq_qdepth;
	uint64_t 	 orig_egress_global_tstamp;
	uint64_t 	 new_egress_global_tstamp;
	uint32_t 	 new_enq_tstamp;
]]


-- variable length fields
qmetadata_snapshot.headerVariableMember = nil

-- Module for qmetadata_snapshot_address struct
local qmetadata_snapshotHeader = initHeader()
qmetadata_snapshotHeader.__index = qmetadata_snapshotHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function qmetadata_snapshotHeader:getINGRESS_GLOBAL_TSTAMP_HI_16()
	return hton16(self.ingress_global_tstamp_hi_16)
end

function qmetadata_snapshotHeader:getINGRESS_GLOBAL_TSTAMP_HI_16string()
	return self:getINGRESS_GLOBAL_TSTAMP_HI_16()
end

function qmetadata_snapshotHeader:setINGRESS_GLOBAL_TSTAMP_HI_16(int)
	int = int or 0
	self.ingress_global_tstamp_hi_16 = hton16(int)
end


function qmetadata_snapshotHeader:getINGRESS_GLOBAL_TSTAMP_LO_32()
	return hton(self.ingress_global_tstamp_lo_32)
end

function qmetadata_snapshotHeader:getINGRESS_GLOBAL_TSTAMP_LO_32string()
	return self:getINGRESS_GLOBAL_TSTAMP_LO_32()
end

function qmetadata_snapshotHeader:setINGRESS_GLOBAL_TSTAMP_LO_32(int)
	int = int or 0
	self.ingress_global_tstamp_lo_32 = hton(int)
end


function qmetadata_snapshotHeader:getEGRESS_GLOBAL_TSTAMP_LO_32()
	return hton(self.egress_global_tstamp_lo_32)
end

function qmetadata_snapshotHeader:getEGRESS_GLOBAL_TSTAMP_LO_32string()
	return self:getEGRESS_GLOBAL_TSTAMP_LO_32()
end

function qmetadata_snapshotHeader:setEGRESS_GLOBAL_TSTAMP_LO_32(int)
	int = int or 0
	self.egress_global_tstamp_lo_32 = hton(int)
end


function qmetadata_snapshotHeader:getENQ_QDEPTH()
	return hton(self.enq_qdepth)
end

function qmetadata_snapshotHeader:getENQ_QDEPTHstring()
	return self:getENQ_QDEPTH()
end

function qmetadata_snapshotHeader:setENQ_QDEPTH(int)
	int = int or 0
	self.enq_qdepth = hton(int)
end


function qmetadata_snapshotHeader:getDEQ_QDEPTH()
	return hton(self.deq_qdepth)
end

function qmetadata_snapshotHeader:getDEQ_QDEPTHstring()
	return self:getDEQ_QDEPTH()
end

function qmetadata_snapshotHeader:setDEQ_QDEPTH(int)
	int = int or 0
	self.deq_qdepth = hton(int)
end


function qmetadata_snapshotHeader:getORIG_EGRESS_GLOBAL_TSTAMP()
	return hton64(self.orig_egress_global_tstamp)
end

function qmetadata_snapshotHeader:getORIG_EGRESS_GLOBAL_TSTAMPstring()
	return self:getORIG_EGRESS_GLOBAL_TSTAMP()
end

function qmetadata_snapshotHeader:setORIG_EGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.orig_egress_global_tstamp = hton64(int)
end


function qmetadata_snapshotHeader:getNEW_EGRESS_GLOBAL_TSTAMP()
	return hton64(self.new_egress_global_tstamp)
end

function qmetadata_snapshotHeader:getNEW_EGRESS_GLOBAL_TSTAMPstring()
	return self:getNEW_EGRESS_GLOBAL_TSTAMP()
end

function qmetadata_snapshotHeader:setNEW_EGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.new_egress_global_tstamp = hton64(int)
end


function qmetadata_snapshotHeader:getNEW_ENQ_TSTAMP()
	return hton(self.new_enq_tstamp)
end

function qmetadata_snapshotHeader:getNEW_ENQ_TSTAMPstring()
	return self:getNEW_ENQ_TSTAMP()
end

function qmetadata_snapshotHeader:setNEW_ENQ_TSTAMP(int)
	int = int or 0
	self.new_enq_tstamp = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function qmetadata_snapshotHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'qmetadata_snapshot'

	self:setINGRESS_GLOBAL_TSTAMP_HI_16(args[pre .. 'INGRESS_GLOBAL_TSTAMP_HI_16'])
	self:setINGRESS_GLOBAL_TSTAMP_LO_32(args[pre .. 'INGRESS_GLOBAL_TSTAMP_LO_32'])
	self:setEGRESS_GLOBAL_TSTAMP_LO_32(args[pre .. 'EGRESS_GLOBAL_TSTAMP_LO_32'])
	self:setENQ_QDEPTH(args[pre .. 'ENQ_QDEPTH'])
	self:setDEQ_QDEPTH(args[pre .. 'DEQ_QDEPTH'])
	self:setORIG_EGRESS_GLOBAL_TSTAMP(args[pre .. 'ORIG_EGRESS_GLOBAL_TSTAMP'])
	self:setNEW_EGRESS_GLOBAL_TSTAMP(args[pre .. 'NEW_EGRESS_GLOBAL_TSTAMP'])
	self:setNEW_ENQ_TSTAMP(args[pre .. 'NEW_ENQ_TSTAMP'])
end

-- Retrieve the values of all members
function qmetadata_snapshotHeader:get(pre)
	pre = pre or 'qmetadata_snapshot'

	local args = {}
	args[pre .. 'INGRESS_GLOBAL_TSTAMP_HI_16'] = self:getINGRESS_GLOBAL_TSTAMP_HI_16()
	args[pre .. 'INGRESS_GLOBAL_TSTAMP_LO_32'] = self:getINGRESS_GLOBAL_TSTAMP_LO_32()
	args[pre .. 'EGRESS_GLOBAL_TSTAMP_LO_32'] = self:getEGRESS_GLOBAL_TSTAMP_LO_32()
	args[pre .. 'ENQ_QDEPTH'] = self:getENQ_QDEPTH()
	args[pre .. 'DEQ_QDEPTH'] = self:getDEQ_QDEPTH()
	args[pre .. 'ORIG_EGRESS_GLOBAL_TSTAMP'] = self:getORIG_EGRESS_GLOBAL_TSTAMP()
	args[pre .. 'NEW_EGRESS_GLOBAL_TSTAMP'] = self:getNEW_EGRESS_GLOBAL_TSTAMP()
	args[pre .. 'NEW_ENQ_TSTAMP'] = self:getNEW_ENQ_TSTAMP()

	return args
end

function qmetadata_snapshotHeader:getString()
	return 'qmetadata_snapshot \n'
		.. 'INGRESS_GLOBAL_TSTAMP_HI_16' .. self:getINGRESS_GLOBAL_TSTAMP_HI_16String() .. '\n'
		.. 'INGRESS_GLOBAL_TSTAMP_LO_32' .. self:getINGRESS_GLOBAL_TSTAMP_LO_32String() .. '\n'
		.. 'EGRESS_GLOBAL_TSTAMP_LO_32' .. self:getEGRESS_GLOBAL_TSTAMP_LO_32String() .. '\n'
		.. 'ENQ_QDEPTH' .. self:getENQ_QDEPTHString() .. '\n'
		.. 'DEQ_QDEPTH' .. self:getDEQ_QDEPTHString() .. '\n'
		.. 'ORIG_EGRESS_GLOBAL_TSTAMP' .. self:getORIG_EGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. 'NEW_EGRESS_GLOBAL_TSTAMP' .. self:getNEW_EGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. 'NEW_ENQ_TSTAMP' .. self:getNEW_ENQ_TSTAMPString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function qmetadata_snapshotHeader:resolveNextHeader()
	return nil
end

function qmetadata_snapshotHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
qmetadata_snapshot.metatype = qmetadata_snapshotHeader

return qmetadata_snapshot