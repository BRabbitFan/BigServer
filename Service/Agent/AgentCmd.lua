-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 15:27:51
-- FilePath     : /BigServer/Service/Agent/AgentCmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"

local SVR = require "GlobalDefine.ServiceName"
local util = require "Util.SvrUtil"

local DATA = require "AgentData"
local base = DATA.base

local _M = {}

function _M.start(conf)
  base.fd = conf.fd
  base.gate = conf.gate
  base.watchdog = conf.watchdog
  skynet.send(util.getSvr(SVR.gate), "lua", "forward", skynet.self(), base.fd, nil, skynet.self())
end

return _M