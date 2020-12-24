--Template for addition of new protocol 'paxos'

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
---- paxos_acceptor_paxos header and constants 
-----------------------------------------------------
local paxos_acceptor_paxos = {}

paxos_acceptor_paxos.headerFormat = [[
    uint8_t      msgtype;
    uint16_t      instance;
    uint8_t      round;
    uint8_t      vround;
    uint64_t      acceptor;
    -- fill blank here 512      value;
]]


-- variable length fields
paxos_acceptor_paxos.headerVariableMember = nil

-- Module for paxos_acceptor_paxos_address struct
local paxos_acceptor_paxosHeader = initHeader()
paxos_acceptor_paxosHeader.__index = paxos_acceptor_paxosHeader


-----------------------------------------------------
---- Getters, Setters and String functions for fields
-----------------------------------------------------
function paxos_acceptor_paxosHeader:getMSGTYPE()
    return (self.msgtype)
end

function paxos_acceptor_paxosHeader:getMSGTYPEstring()
    return self:getMSGTYPE()
end

function paxos_acceptor_paxosHeader:setMSGTYPE(int)
    int = int or 0
    self.msgtype = (int)
end


function paxos_acceptor_paxosHeader:getINSTANCE()
    return hton16(self.instance)
end

function paxos_acceptor_paxosHeader:getINSTANCEstring()
    return self:getINSTANCE()
end

function paxos_acceptor_paxosHeader:setINSTANCE(int)
    int = int or 0
    self.instance = hton16(int)
end


function paxos_acceptor_paxosHeader:getROUND()
    return (self.round)
end

function paxos_acceptor_paxosHeader:getROUNDstring()
    return self:getROUND()
end

function paxos_acceptor_paxosHeader:setROUND(int)
    int = int or 0
    self.round = (int)
end


function paxos_acceptor_paxosHeader:getVROUND()
    return (self.vround)
end

function paxos_acceptor_paxosHeader:getVROUNDstring()
    return self:getVROUND()
end

function paxos_acceptor_paxosHeader:setVROUND(int)
    int = int or 0
    self.vround = (int)
end


function paxos_acceptor_paxosHeader:getACCEPTOR()
    return hton64(self.acceptor)
end

function paxos_acceptor_paxosHeader:getACCEPTORstring()
    return self:getACCEPTOR()
end

function paxos_acceptor_paxosHeader:setACCEPTOR(int)
    int = int or 0
    self.acceptor = hton64(int)
end


function paxos_acceptor_paxosHeader:getVALUE()
    return (self.value:get())
end

function paxos_acceptor_paxosHeader:getVALUEstring()
    return self:getVALUE()
end

function paxos_acceptor_paxosHeader:setVALUE(int)
    int = int or 0
    self.value:set(int)
end



-----------------------------------------------------
---- Functions for full header
-----------------------------------------------------
-- Set all members of the PROTO header
function paxos_acceptor_paxosHeader:fill(args,pre)
    args = args or {}
    pre = pre or 'paxos_acceptor_paxos'

    self:setMSGTYPE(args[pre .. 'MSGTYPE'])
    self:setINSTANCE(args[pre .. 'INSTANCE'])
    self:setROUND(args[pre .. 'ROUND'])
    self:setVROUND(args[pre .. 'VROUND'])
    self:setACCEPTOR(args[pre .. 'ACCEPTOR'])
    self:setVALUE(args[pre .. 'VALUE'])
end

-- Retrieve the values of all members
function paxos_acceptor_paxosHeader:get(pre)
    pre = pre or 'paxos_acceptor_paxos'

    local args = {}
    args[pre .. 'MSGTYPE'] = self:getMSGTYPE()
    args[pre .. 'INSTANCE'] = self:getINSTANCE()
    args[pre .. 'ROUND'] = self:getROUND()
    args[pre .. 'VROUND'] = self:getVROUND()
    args[pre .. 'ACCEPTOR'] = self:getACCEPTOR()
    args[pre .. 'VALUE'] = self:getVALUE()

    return args
end

function paxos_acceptor_paxosHeader:getString()
    return 'paxos_acceptor_paxos \n'
        .. 'MSGTYPE' .. self:getMSGTYPEString() .. '\n'
        .. 'INSTANCE' .. self:getINSTANCEString() .. '\n'
        .. 'ROUND' .. self:getROUNDString() .. '\n'
        .. 'VROUND' .. self:getVROUNDString() .. '\n'
        .. 'ACCEPTOR' .. self:getACCEPTORString() .. '\n'
        .. 'VALUE' .. self:getVALUEString() .. '\n'
end

-- Dictionary for next level headers
local nextHeaderResolve = {
}
function paxos_acceptor_paxosHeader:resolveNextHeader()
    return nil
end

function paxos_acceptor_paxosHeader:setDefaultNamedArgs(pre, namedArgs, nextHeader, accumulatedLength)
    return namedArgs
end

-----------------------------------------------------
---- Metatypes
-----------------------------------------------------
paxos_acceptor_paxos.metatype = paxos_acceptor_paxosHeader

return paxos_acceptor_paxos