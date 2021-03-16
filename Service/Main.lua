-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2020-12-31 18:28:01
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:43:10
-- FilePath     : /BigServer/Service/Main.lua
-- Description  : 入口服务---启动各项服务
-- -----------------------------

local skynet = require "skynet"
local sharedata = require "skynet.sharedata"

local util = require "Util.SvrUtil"

local SVR_NAME = require "GlobalDefine.ServiceName"

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

-- 启动数据中心
local function startDataCenter()
	local dataCenter = skynet.newservice("DataCenter")
	skynet.call(dataCenter, "lua", "start", {
		svrName = SVR_NAME.dataCenter,
	})
end

-- 启动数据库服务
local function startDatabase()
	local database = skynet.newservice("Database")
	skynet.call(database, "lua", "start", {
		svrName = SVR_NAME.database,
	})
end

-- 启动配置服务
local function startConfigLoader()
	local confServer = skynet.newservice("ConfigLoader")
	skynet.call(confServer, "lua", "start", {
		isReload = false,
	})
end

-- 启动登录服务
local function startLogin()
	local loginServer = skynet.newservice("Login")
	skynet.call(loginServer, "lua", "start", {
		svrName = SVR_NAME.login,
	})
end

-- 启动游戏大厅
local function startHall()
	local hall = skynet.newservice("Hall")
	skynet.call(hall, "lua", "start", {
		svrName = SVR_NAME.hall,
	})
end

skynet.start(function()
	startGate()
	startDataCenter()
	startDatabase()
	startConfigLoader()
	startLogin()
	startHall()
	skynet.exit()
end)
