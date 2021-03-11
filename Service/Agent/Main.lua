-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:39:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-11 22:53:27
-- FilePath     : /BigServer/Service/Agent/Main.lua
-- Description  : Agent服务入口 -- 一个Agent对应一个Client
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"
local netpack = require "skynet.netpack"

local PbMap = require "Util.PbMap"
local util = require "Util.BaseUtil"

local CMD = require "AgentCmd"
local MSG = require "AgentMsg"
local DATA = require "AgentData"

skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  pack = skynet.pack,
  unpack = netpack.tostring,
})

skynet.start(function()

  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = CMD[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)

  skynet.dispatch("client", function(session, source, ...)
    local msgName, msgTable = PbMap.unpack(...)
    local func = MSG[msgName]
    if func then
      func(msgTable)  -- 网关来的消息不用返回
    end
  end)

end)