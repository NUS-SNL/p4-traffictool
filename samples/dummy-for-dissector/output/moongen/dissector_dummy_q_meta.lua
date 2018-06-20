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
---- Q_META header and constants 
-----------------------------------------------------
local Q_META = {}

Q_META.headerFormat = [[
	uint16_t 	 flow_id;
	uint16_t 	 _pad0;
	union bitfield_48 	 ingress_global_tstamp;
	uint16_t 	 _pad1;
	union bitfield_48 	 egress_global_tstamp;
	uint16_t 	 _spare_pad_bits;
	uint8_t 	 markbit;
	uint16_t 	 _pad2;
	union bitfield_24 	 enq_qdepth;
	uint16_t 	 _pad3;
	union bitfield_24 	 deq_qdepth;
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
	return hton16(self.flow_id)
end

function Q_METAHeader:getFLOW_IDstring()
	return self:getFLOW_ID()
end

function Q_METAHeader:setFLOW_ID(int)
	int = int or 0
	self.flow_id = hton16(int)
end


function Q_METAHeader:get_PAD0()
	return hton16(self._pad0)
end

function Q_METAHeader:get_PAD0string()
	return self:get_PAD0()
end

function Q_METAHeader:set_PAD0(int)
	int = int or 0
	self._pad0 = hton16(int)
end


function Q_METAHeader:getINGRESS_GLOBAL_TSTAMP()
	return (self.ingress_global_tstamp:get())
end

function Q_METAHeader:getINGRESS_GLOBAL_TSTAMPstring()
	return self:getINGRESS_GLOBAL_TSTAMP()
end

function Q_METAHeader:setINGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.ingress_global_tstamp:set(int)
end


function Q_METAHeader:get_PAD1()
	return hton16(self._pad1)
end

function Q_METAHeader:get_PAD1string()
	return self:get_PAD1()
end

function Q_METAHeader:set_PAD1(int)
	int = int or 0
	self._pad1 = hton16(int)
end


function Q_METAHeader:getEGRESS_GLOBAL_TSTAMP()
	return (self.egress_global_tstamp:get())
end

function Q_METAHeader:getEGRESS_GLOBAL_TSTAMPstring()
	return self:getEGRESS_GLOBAL_TSTAMP()
end

function Q_METAHeader:setEGRESS_GLOBAL_TSTAMP(int)
	int = int or 0
	self.egress_global_tstamp:set(int)
end


function Q_METAHeader:get_SPARE_PAD_BITS()
	return hton16(self._spare_pad_bits:get())
end

function Q_METAHeader:get_SPARE_PAD_BITSstring()
	return self:get_SPARE_PAD_BITS()
end

function Q_METAHeader:set_SPARE_PAD_BITS(int)
	int = int or 0
	self._spare_pad_bits:sethton16(int)
end


function Q_METAHeader:getMARKBIT()
	return (self.markbit)
end

function Q_METAHeader:getMARKBITstring()
	return self:getMARKBIT()
end

function Q_METAHeader:setMARKBIT(int)
	int = int or 0
	self.markbit = (int)
end


function Q_METAHeader:get_PAD2()
	return hton16(self._pad2:get())
end

function Q_METAHeader:get_PAD2string()
	return self:get_PAD2()
end

function Q_METAHeader:set_PAD2(int)
	int = int or 0
	self._pad2:sethton16(int)
end


function Q_METAHeader:getENQ_QDEPTH()
	return (self.enq_qdepth:get())
end

function Q_METAHeader:getENQ_QDEPTHstring()
	return self:getENQ_QDEPTH()
end

function Q_METAHeader:setENQ_QDEPTH(int)
	int = int or 0
	self.enq_qdepth:set(int)
end


function Q_METAHeader:get_PAD3()
	return hton16(self._pad3:get())
end

function Q_METAHeader:get_PAD3string()
	return self:get_PAD3()
end

function Q_METAHeader:set_PAD3(int)
	int = int or 0
	self._pad3:sethton16(int)
end


function Q_METAHeader:getDEQ_QDEPTH()
	return (self.deq_qdepth:get())
end

function Q_METAHeader:getDEQ_QDEPTHstring()
	return self:getDEQ_QDEPTH()
end

function Q_METAHeader:setDEQ_QDEPTH(int)
	int = int or 0
	self.deq_qdepth:set(int)
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

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function Q_METAHeader:resolveNextHeader()
	return nil
end


-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
ffi.metatype('union bitfield_24',bitfield24)
ffi.metatype('union bitfield_40',bitfield40)
ffi.metatype('union bitfield_48',bitfield48)Q_META.metatype = Q_METAHeader

return Q_META