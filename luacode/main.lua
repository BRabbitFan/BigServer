local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local sharedata = require "sharedata"

local function startGate()
	-- local watchdog = skynet.newservice("watchdog")
	-- skynet.call(watchdog, "lua", "start", {
	-- 	port = 8888,
	-- 	maxclient = max_client,
	-- 	nodelay = true,
	-- })
	local gateway_port = skynet.getenv("gateway_port") or 8000
	local max_client = skynet.getenv("max_client") or 32
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = gateway_port,
		maxclient = max_client,
		nodelay = true,
		servername = "gate",
	})
	sharedata.new("gate", watchdog)
end

skynet.start(function()
	skynet.error("Big Start!")
	startGate()
	-- skynet.error("Server start")
	-- skynet.uniqueservice("protoloader")
	-- if not skynet.getenv "daemon" then
	-- 	local console = skynet.newservice("console")
	-- end
	-- skynet.newservice("debug_console",8000)
	-- skynet.newservice("simpledb")

	-- skynet.error("Watchdog listen on", 8888)
	skynet.exit()
end)
