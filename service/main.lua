-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-19 22:07:34
-- FilePath     : /BigServer/luacode/main.lua
-- Description  : 入口服务---启动各项服务
-- -----------------------------

local skynet = require "skynet"

---启动网关(gate, watchdog)
local function startGateway()
	local gateway_port = skynet.getenv("gateway_port") or 8000
	local max_client = skynet.getenv("max_client") or 32
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = gateway_port,
		maxclient = max_client,
		nodelay = true,
		servername = "gate",
	})
end

skynet.start(function()
	startGateway()
	skynet.exit()
end)
