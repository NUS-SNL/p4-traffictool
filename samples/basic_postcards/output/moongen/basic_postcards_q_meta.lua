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
---- basic_postcards_q_meta header and constants 
-----------------------------------------------------
local basic_postcards_q_meta = {}

basic_postcards_q_meta.headerFormat = [[
    union bitfield_24      enq_qdepth;
    union bitfield_24      deq_qdepth;
    uint32_t      deq_timedelta;
    uint32_t      enq_timestamp;
]]


-- variable length fields
basic_postcards_q_meta.headerVariableMember = nil

-- Module for basic_postcards_q_meta_address struct
local basic_postcards_q_metaHeader = initHeader()
basic_postcards_q_metaHeader.__index = basic_postcards_q_metaHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function basic_postcards_q_metaHeader:getENQ_QDEPTH()
    return (self.enq_qdepth:get())
end

function basic_postcards_q_metaHeader:getENQ_QDEPTHstring()
    return self:getENQ_QDEPTH()
end

function basic_postcards_q_metaHeader:setENQ_QDEPTH(int)
    int = int or 0
    self.enq_qdepth:set(int)
end


function basic_postcards_q_metaHeader:getDEQ_QDEPTH()
    return (self.deq_qdepth:get())
end

function basic_postcards_q_metaHeader:getDEQ_QDEPTHstring()
    return self:getDEQ_QDEPTH()
end

function basic_postcards_q_metaHeader:setDEQ_QDEPTH(int)
    int = int or 0
    self.deq_qdepth:set(int)
end


function basic_postcards_q_metaHeader:getDEQ_TIMEDELTA()
    return hton(self.deq_timedelta)
end

function basic_postcards_q_metaHeader:getDEQ_TIMEDELTAstring()
    return self:getDEQ_TIMEDELTA()
end

function basic_postcards_q_metaHeader:setDEQ_TIMEDELTA(int)
    int = int or 0
    self.deq_timedelta = hton(int)
end


function basic_postcards_q_metaHeader:getENQ_TIMESTAMP()
    return hton(self.enq_timestamp)
end

function basic_postcards_q_metaHeader:getENQ_TIMESTAMPstring()
    return self:getENQ_TIMESTAMP()
end

function basic_postcards_q_metaHeader:setENQ_TIMESTAMP(int)
    int = int or 0
    self.enq_timestamp = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function basic_postcards_q_metaHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'basic_postcards_q_meta'

    self:setENQ_QDEPTH(args[pre .. 'ENQ_QDEPTH'])
    self:setDEQ_QDEPTH(args[pre .. 'DEQ_QDEPTH'])
    self:setDEQ_TIMEDELTA(args[pre .. 'DEQ_TIMEDELTA'])
    self:setENQ_TIMESTAMP(args[pre .. 'ENQ_TIMESTAMP'])
end

-- Retrieve the values of all members
function basic_postcards_q_metaHeader:get(pre)
    pre = pre or 'basic_postcards_q_meta'

    local args = {}
    args[pre .. 'ENQ_QDEPTH'] = self:getENQ_QDEPTH()
    args[pre .. 'DEQ_QDEPTH'] = self:getDEQ_QDEPTH()
    args[pre .. 'DEQ_TIMEDELTA'] = self:getDEQ_TIMEDELTA()
    args[pre .. 'ENQ_TIMESTAMP'] = self:getENQ_TIMESTAMP()

    return args
end

function basic_postcards_q_metaHeader:getString()
    return 'basic_postcards_q_meta \n'
        .. 'ENQ_QDEPTH' .. self:getENQ_QDEPTHString() .. '\n'
        .. 'DEQ_QDEPTH' .. self:getDEQ_QDEPTHString() .. '\n'
        .. 'DEQ_TIMEDELTA' .. self:getDEQ_TIMEDELTAString() .. '\n'
        .. 'ENQ_TIMESTAMP' .. self:getENQ_TIMESTAMPString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function basic_postcards_q_metaHeader:resolveNextHeader()
    return nil
end

function basic_postcards_q_metaHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
basic_postcards_q_meta.metatype = basic_postcards_q_metaHeader

return basic_postcards_q_meta