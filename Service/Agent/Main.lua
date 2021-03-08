-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:39:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-08 13:53:43
-- FilePath     : /BigServer/Service/Agent/Main.lua
-- Description  : Agent服务入口 -- 一个Agent对应一个Client
-- -----------------------------

local skynet = require "skynet"
local netpack = require "skynet.netpack"

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
    local f = CMD[cmd]
    if f then
      skynet.retpack(f(...))
    end
  end)

  skynet.dispatch("client", function(session, source, ...)
    print(...)
    if ... == "close" then
      CMD.close(...)
    end
    -- print(session, source, cmd, ...)
    -- local f = MSG[cmd]
    -- if f then
    --   skynet.retpack(f(...))
    -- end
  end)

end)