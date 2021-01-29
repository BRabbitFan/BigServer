-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 21:37:00
-- FilePath     : /BigServer/service/agent/agent_cmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"

local DATA = require "agent_data"
local base = DATA.base

local _M = {}

function _M.start(conf)
  base.client = conf.client
  base.gate = conf.gate
  base.watchdog = conf.watchdog
  skynet.send()
end

return _M