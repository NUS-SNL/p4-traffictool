--Template for addition of new protocol 'q_meta'

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
---- Q_META header and constants 
-----------------------------------------------------
local Q_META = {}

Q_META.headerFormat = [[
	16 	 flow_id;
	16 	 _pad0;
	48 	 ingress_global_tstamp;
	16 	 _pad1;
	48 	 egress_global_tstamp;
	15 	 _spare_pad_bits;
	1 	 markbit;
	13 	 _pad2;
	19 	 enq_qdepth;
	13 	 _pad3;
	19 	 deq_qdepth;
]]


-- variable length fields
Q_META.headerVariableMember = nil

-- Module for Q_META_address struct
local Q_METAHeader = initHeader()
Q_METAHeader.__index = Q_METAHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function Q_METAHeader:getFLOW_ID()
	return hton(self.flow_id)
end

function Q_METAHeader:getFLOW_IDstring()
	return self:getFLOW_ID()
end

function Q_METAHeader:setFLOW_ID(int)
	int = int or 0
	self.flow_id = hton(int)
end


function Q_METAHeader:get_PAD0()
	return hton(self._pad0)
end

function Q_METAHeader:get_PAD0string()
	return self:get_PAD0()
end

function Q_METAHeader:set_PAD0(int)
	int = int or 0
	self._pad0 = hton(int)
end


function Q_METAHeader:getINGRESS_GLOBAL_TSTAMP()
	return hton(self.ingress_global_tstamp)
end

function Q_METAHeader:getINGRESS_GLOBAL_TSTAMPstring()
	return self:getINGRESS_GLOBAL_TSTAMP()
end

function Q_METAHeader:setINGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.ingress_global_tstamp = hton(int)
end


function Q_METAHeader:get_PAD1()
	return hton(self._pad1)
end

function Q_METAHeader:get_PAD1string()
	return self:get_PAD1()
end

function Q_METAHeader:set_PAD1(int)
	int = int or 0
	self._pad1 = hton(int)
end


function Q_METAHeader:getEGRESS_GLOBAL_TSTAMP()
	return hton(self.egress_global_tstamp)
end

function Q_METAHeader:getEGRESS_GLOBAL_TSTAMPstring()
	return self:getEGRESS_GLOBAL_TSTAMP()
end

function Q_METAHeader:setEGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.egress_global_tstamp = hton(int)
end


function Q_METAHeader:get_SPARE_PAD_BITS()
	return hton(self._spare_pad_bits)
end

function Q_METAHeader:get_SPARE_PAD_BITSstring()
	return self:get_SPARE_PAD_BITS()
end

function Q_METAHeader:set_SPARE_PAD_BITS(int)
	int = int or 0
	self._spare_pad_bits = hton(int)
end


function Q_METAHeader:getMARKBIT()
	return hton(self.markbit)
end

function Q_METAHeader:getMARKBITstring()
	return self:getMARKBIT()
end

function Q_METAHeader:setMARKBIT(int)
	int = int or 0
	self.markbit = hton(int)
end


function Q_METAHeader:get_PAD2()
	return hton(self._pad2)
end

function Q_METAHeader:get_PAD2string()
	return self:get_PAD2()
end

function Q_METAHeader:set_PAD2(int)
	int = int or 0
	self._pad2 = hton(int)
end


function Q_METAHeader:getENQ_QDEPTH()
	return hton(self.enq_qdepth)
end

function Q_METAHeader:getENQ_QDEPTHstring()
	return self:getENQ_QDEPTH()
end

function Q_METAHeader:setENQ_QDEPTH(int)
	int = int or 0
	self.enq_qdepth = hton(int)
end


function Q_METAHeader:get_PAD3()
	return hton(self._pad3)
end

function Q_METAHeader:get_PAD3string()
	return self:get_PAD3()
end

function Q_METAHeader:set_PAD3(int)
	int = int or 0
	self._pad3 = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function Q_METAHeader:fill(args,pre)
	args = args or {}
	pre = pre or 'Q_META'

	self:setFLOW_ID(args[pre .. 'FLOW_ID'])
	self:set_PAD0(args[pre .. '_PAD0'])
	self:setINGRESS_GLOBAL_TSTAMP(args[pre .. 'INGRESS_GLOBAL_TSTAMP'])
	self:set_PAD1(args[pre .. '_PAD1'])
	self:setEGRESS_GLOBAL_TSTAMP(args[pre .. 'EGRESS_GLOBAL_TSTAMP'])
	self:set_SPARE_PAD_BITS(args[pre .. '_SPARE_PAD_BITS'])
	self:setMARKBIT(args[pre .. 'MARKBIT'])
	self:set_PAD2(args[pre .. '_PAD2'])
	self:setENQ_QDEPTH(args[pre .. 'ENQ_QDEPTH'])
	self:set_PAD3(args[pre .. '_PAD3'])
	self:setDEQ_QDEPTH(args[pre .. 'DEQ_QDEPTH'])
end

-- Retrieve the values of all members
function Q_METAHeader:get(pre)
	pre = pre or 'Q_META'

	local args = {}
	args[pre .. 'FLOW_ID'] = self:getFLOW_ID()
	args[pre .. '_PAD0'] = self:get_PAD0()
	args[pre .. 'INGRESS_GLOBAL_TSTAMP'] = self:getINGRESS_GLOBAL_TSTAMP()
	args[pre .. '_PAD1'] = self:get_PAD1()
	args[pre .. 'EGRESS_GLOBAL_TSTAMP'] = self:getEGRESS_GLOBAL_TSTAMP()
	args[pre .. '_SPARE_PAD_BITS'] = self:get_SPARE_PAD_BITS()
	args[pre .. 'MARKBIT'] = self:getMARKBIT()
	args[pre .. '_PAD2'] = self:get_PAD2()
	args[pre .. 'ENQ_QDEPTH'] = self:getENQ_QDEPTH()
	args[pre .. '_PAD3'] = self:get_PAD3()
	args[pre .. 'DEQ_QDEPTH'] = self:getDEQ_QDEPTH()

	return args
end

function Q_METAHeader:getString()
	return 'Q_META \n'
		.. 'FLOW_ID' .. self:getFLOW_IDString() .. '\n'
		.. '_PAD0' .. self:get_PAD0String() .. '\n'
		.. 'INGRESS_GLOBAL_TSTAMP' .. self:getINGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. '_PAD1' .. self:get_PAD1String() .. '\n'
		.. 'EGRESS_GLOBAL_TSTAMP' .. self:getEGRESS_GLOBAL_TSTAMPString() .. '\n'
		.. '_SPARE_PAD_BITS' .. self:get_SPARE_PAD_BITSString() .. '\n'
		.. 'MARKBIT' .. self:getMARKBITString() .. '\n'
		.. '_PAD2' .. self:get_PAD2String() .. '\n'
		.. 'ENQ_QDEPTH' .. self:getENQ_QDEPTHString() .. '\n'
		.. '_PAD3' .. self:get_PAD3String() .. '\n'
		.. 'DEQ_QDEPTH' .. self:getDEQ_QDEPTHString() .. '\n'
end

-- Dictionary for next level headerslocal nextHeaderResolve = {
-- Dictionary for next level headers
local nextHeaderResolve = {
}
function Q_METAHeader:resolveNextHeader()
	 return final
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
Q_META.metatype = Q_METAHeader

return Q_META