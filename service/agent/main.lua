-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:39:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-29 20:02:43
-- FilePath     : /BigServer/service/agent/main.lua
-- Description  : Agent服务入口 -- 一个Agent对应一个Client
-- -----------------------------

local skynet = require "skynet"

local CMD = require "cmd"

local MSG = require "msg"

local DATA = require "data"

skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  pack = skynet.pack,
  unpack = skynet.unpack,
})

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
  skynet.dispatch("client", function(session, source, cmd, ...)
    local f = MSG[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)
end)