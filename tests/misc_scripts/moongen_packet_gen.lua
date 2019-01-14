local mg     = require "moongen"
local memory = require "memory"
local device = require "device"
local ts     = require "timestamping"
local stats  = require "stats"
local hist   = require "histogram"

local PKT_SIZE	= 80
local ETH_DST	= "11:12:13:14:15:16"

local function getRstFile(...)
	local args = { ... }
	for i, v in ipairs(args) do
		result, count = string.gsub(v, "%-%-result%=", "")
		if (count == 1) then
			return i, result
		end
	end
	return nil, nil
end

function configure(parser)
	parser:description("Generates bidirectional CBR traffic with hardware rate control and measure latencies.")
	parser:argument("dev1", "Device to transmit/receive from."):convert(tonumber)
	parser:option("-r --rate", "Transmit rate in Mbit/s."):default(10000):convert(tonumber)
	parser:option("-f --file", "Filename of the latency histogram."):default("histogram.csv")
end

function master(args)
	local dev1 = device.config({port = args.dev1, rxQueues = 2, txQueues = 2})
	device.waitForLinks()
	dev1:getTxQueue(0):setRate(args.rate)
	mg.startTask("loadSlave", dev1:getTxQueue(0))
	stats.startStatsTask{dev1}
	mg.waitForTasks()
end

function loadSlave(queue)
	local mem = memory.createMemPool(function(buf)
		buf:getTestPacket():fill{}   	-- modify packet name here
	end)
	local bufs = mem:bufArray()
	while mg.running() do
		bufs:alloc(PKT_SIZE)
		queue:send(bufs)
	end
end

