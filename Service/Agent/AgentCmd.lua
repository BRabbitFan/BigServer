-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:10
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-08 14:01:23
-- FilePath     : /BigServer/Service/Agent/AgentCmd.lua
-- Description  : agent的命令
-- -----------------------------

local skynet = require "skynet"

local SVR = require "GlobalDefine.ServiceName"
local util = require "Util.SvrUtil"

local DATA = require "AgentData"

local _M = {}

function _M.start(conf)
  util.log(" [Agent] [CMD.start] " .. util.tabToStr(conf))
  local base = DATA.base
  base.fd = conf.fd
  base.gate = conf.gate
  -- local s = util.getSvr(SVR.gate)
  -- util.log(" [Agent] [CMD.start] "..SVR.gate.." "..type(SVR.gate).." "..s.." "..type(s))
  skynet.send(SVR.gate, "lua", "forward", base.fd)
end

function _M.close(...)
  util.log(" [Agent] [CMD.close] ")
  local fd = DATA.base.fd
  skynet.send(SVR.gate, "lua", "unforward", fd)
  skynet.exit()
end

return _M