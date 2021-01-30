-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:17:59
-- FilePath     : /BigServer/Service/Agent/AgentCmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"

local DATA = require "AgentData"
local base = DATA.base

local _M = {}

function _M.start(conf)
  base.client = conf.client
  base.gate = conf.gate
  base.watchdog = conf.watchdog
  skynet.send()
end

return _M