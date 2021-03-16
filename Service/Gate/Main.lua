-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-06 16:08:44
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-08 14:32:06
-- FilePath     : /BigServer/Service/Gate/Main.lua
-- Description  : 网关
-- -----------------------------

local skynet = require "skynet.manager"
local gateserver = require "snax.gateserver"

local SVR_NAME = require "GameConfig.ServiceName"
local util = require "Util.SvrUtil"

local Handler = require "GateHandler"  -- 处理客户端消息
local Cmd = require "GateCmd"  -- 处理服务器命令
local Data = {}  -- 网关数据

-- 启动网关
gateserver.start(Handler)