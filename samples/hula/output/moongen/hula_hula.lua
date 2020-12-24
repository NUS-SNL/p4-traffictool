--Template for addition of new protocol 'hula'

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
---- hula_hula header and constants 
-----------------------------------------------------
local hula_hula = {}

hula_hula.headerFormat = [[
    uint8_t      dir;
    uint16_t      qdepth;
    uint32_t      digest;
]]


-- variable length fields
hula_hula.headerVariableMember = nil

-- Module for hula_hula_address struct
local hula_hulaHeader = initHeader()
hula_hulaHeader.__index = hula_hulaHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function hula_hulaHeader:getDIR()
    return (self.dir)
end

function hula_hulaHeader:getDIRstring()
    return self:getDIR()
end

function hula_hulaHeader:setDIR(int)
    int = int or 0
    self.dir = (int)
end


function hula_hulaHeader:getQDEPTH()
    return hton16(self.qdepth)
end

function hula_hulaHeader:getQDEPTHstring()
    return self:getQDEPTH()
end

function hula_hulaHeader:setQDEPTH(int)
    int = int or 0
    self.qdepth = hton16(int)
end


function hula_hulaHeader:getDIGEST()
    return hton(self.digest)
end

function hula_hulaHeader:getDIGESTstring()
    return self:getDIGEST()
end

function hula_hulaHeader:setDIGEST(int)
    int = int or 0
    self.digest = hton(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function hula_hulaHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'hula_hula'

    self:setDIR(args[pre .. 'DIR'])
    self:setQDEPTH(args[pre .. 'QDEPTH'])
    self:setDIGEST(args[pre .. 'DIGEST'])
end

-- Retrieve the values of all members
function hula_hulaHeader:get(pre)
    pre = pre or 'hula_hula'

    local args = {}
    args[pre .. 'DIR'] = self:getDIR()
    args[pre .. 'QDEPTH'] = self:getQDEPTH()
    args[pre .. 'DIGEST'] = self:getDIGEST()

    return args
end

function hula_hulaHeader:getString()
    return 'hula_hula \n'
        .. 'DIR' .. self:getDIRString() .. '\n'
        .. 'QDEPTH' .. self:getQDEPTHString() .. '\n'
        .. 'DIGEST' .. self:getDIGESTString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function hula_hulaHeader:resolveNextHeader()
    return srcRoutes
end

function hula_hulaHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
hula_hula.metatype = hula_hulaHeader

return hula_hula