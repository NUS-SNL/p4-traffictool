--Template for addition of new protocol 'q_meta'

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
---- qmetadata_q_meta header and constants 
-----------------------------------------------------
local qmetadata_q_meta = {}

qmetadata_q_meta.headerFormat = [[
	uint16_t 	 flow_id;
	uint64_t 	 ingress_global_tstamp;
	uint64_t 	 egress_global_tstamp;
	uint16_t 	 markbit;
	union bitfield_24 	 enq_qdepth;
	union bitfield_24 	 deq_qdepth;
]]


-- variable length fields
qmetadata_q_meta.headerVariableMember = nil

-- Module for qmetadata_q_meta_address struct
local qmetadata_q_metaHeader = initHeader()
qmetadata_q_metaHeader.__index = qmetadata_q_metaHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function qmetadata_q_metaHeader:getFLOW_ID()
	return hton16(self.flow_id)
end

function qmetadata_q_metaHeader:getFLOW_IDstring()
	return self:getFLOW_ID()
end

function qmetadata_q_metaHeader:setFLOW_ID(int)
	int = int or 0
	self.flow_id = hton16(int)
end


function qmetadata_q_metaHeader:getINGRESS_GLOBAL_TSTAMP()
	return hton64(self.ingress_global_tstamp)
end

function qmetadata_q_metaHeader:getINGRESS_GLOBAL_TSTAMPstring()
	return self:getINGRESS_GLOBAL_TSTAMP()
end

function qmetadata_q_metaHeader:setINGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.ingress_global_tstamp = hton64(int)
end


function qmetadata_q_metaHeader:getEGRESS_GLOBAL_TSTAMP()
	return hton64(self.egress_global_tstamp)
end

function qmetadata_q_metaHeader:getEGRESS_GLOBAL_TSTAMPstring()
	return self:getEGRESS_GLOBAL_TSTAMP()
end

function qmetadata_q_metaHeader:setEGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.egress_global_tstamp = hton64(int)
end


function qmetadata_q_metaHeader:getMARKBIT()
	return hton16(self.markbit)
end

function qmetadata_q_metaHeader:getMARKBITstring()
	return self:getMARKBIT()
end

function qmetadata_q_metaHeader:setMARKBIT(int)
	int = int or 0
	self.markbit = hton16(int)
end


function qmetadata_q_metaHeader:getENQ_QDEPTH()
	return (self.enq_qdepth:get())
end

function qmetadata_q_metaHeader:getENQ_QDEPTHstring()
	return self:getENQ_QDEPTH()
end

function qmetadata_q_metaHeader:setENQ_QDEPTH(int)
	int = int or 0
	self.enq_qdepth:set(int)
end


function qmetadata_q_metaHeader:getDEQ_QDEPTH()
	return (self.deq_qdepth:get())
end

function qmetadata_q_metaHeader:getDEQ_QDEPTHstring()
	return self:getDEQ_QDEPTH()
end

function qmetadata_q_metaHeader:setDEQ_QDEPTH(int)
	int = int or 0
	self.deq_qdepth:set(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function qmetadata_q_metaHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'qmetadata_q_meta'

	self:setFLOW_ID(args[pre .. 'FLOW_ID'])
	self:setINGRESS_GLOBAL_TSTAMP(args[pre .. 'INGRESS_GLOBAL_TSTAMP'])
	self:setEGRESS_GLOBAL_TSTAMP(args[pre .. 'EGRESS_GLOBAL_TSTAMP'])
	self:setMARKBIT(args[pre .. 'MARKBIT'])
	self:setENQ_QDEPTH(args[pre .. 'ENQ_QDEPTH'])
	self:setDEQ_QDEPTH(args[pre .. 'DEQ_QDEPTH'])
end

-- Retrieve the values of all members
function qmetadata_q_metaHeader:get(pre)
	pre = pre or 'qmetadata_q_meta'

	local args = {}
	args[pre .. 'FLOW_ID'] = self:getFLOW_ID()
	args[pre .. 'INGRESS_GLOBAL_TSTAMP'] = self:getINGRESS_GLOBAL_TSTAMP()
	args[pre .. 'EGRESS_GLOBAL_TSTAMP'] = self:getEGRESS_GLOBAL_TSTAMP()
	args[pre .. 'MARKBIT'] = self:getMARKBIT()
	args[pre .. 'ENQ_QDEPTH'] = self:getENQ_QDEPTH()
	args[pre .. 'DEQ_QDEPTH'] = self:getDEQ_QDEPTH()

	return args
end

function qmetadata_q_metaHeader:getString()
	return 'qmetadata_q_meta \n'
		.. 'FLOW_ID' .. self:getFLOW_IDString() .. '\n'
		.. 'INGRESS_GLOBAL_TSTAMP' .. self:getINGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. 'EGRESS_GLOBAL_TSTAMP' .. self:getEGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. 'MARKBIT' .. self:getMARKBITString() .. '\n'
		.. 'ENQ_QDEPTH' .. self:getENQ_QDEPTHString() .. '\n'
		.. 'DEQ_QDEPTH' .. self:getDEQ_QDEPTHString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function qmetadata_q_metaHeader:resolveNextHeader()
	return nil
end

function qmetadata_q_metaHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
	return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
qmetadata_q_meta.metatype = qmetadata_q_metaHeader

return qmetadata_q_meta