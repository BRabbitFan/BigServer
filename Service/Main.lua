-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-06 16:19:39
-- FilePath     : /BigServer/Service/Main.lua
-- Description  : 入口服务---启动各项服务
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local util = require "Util.SvrUtil"

local SVR_NAME = require "GlobalDefine.ServiceName"

---启动网关(gate, watchdog)
local function startGateway()
	local gateway_port = skynet.getenv("gateway_port") or 8000
	local max_client = skynet.getenv("max_client") or 32
	local watchdog = skynet.newservice("Watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = gateway_port,
		maxclient = max_client,
		nodelay = true,
		servername = SVR_NAME.gate,
	})
end

-- 启动网关
local function startGate()
	local gateway_port = skynet.getenv("gateway_port") or 8000
	local max_client = skynet.getenv("max_client") or 32
	local gate = skynet.newservice("Gate")
	skynet.call(gate, "lua", "open" , {
		port = gateway_port,
		maxclient = max_client,
		nodelay = true,
		servername = SVR_NAME.gate,
	})
end

---启动数据中心
local function startDataCenter()
	local dataCenter = skynet.newservice("DataCenter")
	skynet.call(dataCenter, "lua", "start", {
		svrName = SVR_NAME.dataCenter,
	})
end

---启动配置服务
local function startConfigLoader()
	local confServer = skynet.newservice("ConfigLoader")
	skynet.call(confServer, "lua", "start", {
		isReload = false,
	})
end

skynet.start(function()
	-- startGateway()
	startGate()
	startDataCenter()
	startConfigLoader()
	-- local CONF = sharedata.query("CONF")
	-- print(util.tabToStr(CONF))
	-- print(CONF.ServiceName.gate)
	skynet.exit()
end)
