local skynet = require "skynet"
require "skynet.manager"
require "util"
local sprotoloader = require "sprotoloader"
local sharedata = require "skynet.sharedata"

---启动网关
local function startGateway()
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
	print(watchdog)
	-- sharedata.new("watchdog", {watchdog})
	
end

skynet.start(function()
	-- skynet.error("Server start")
	-- skynet.uniqueservice("protoloader")
	-- if not skynet.getenv "daemon" then
	-- 	local console = skynet.newservice("console")
	-- end
	-- skynet.newservice("debug_console",8000)
	-- skynet.newservice("simpledb")

	-- skynet.error("Watchdog listen on", 8888)

	skynet.error("Big Start!")
	startGateway()
	-- local watchdog = sharedata.query("watchdog")
	-- print(watchdog[1])
	-- local watchdog = skynet.queryname "watchdog"
	-- local watchdog = skynet.localname(skynet.getenv("watchdog"))
	local watchdog = GetSvr("watchdog")
	print(type(watchdog))
	print(watchdog)
	skynet.exit()
end)
