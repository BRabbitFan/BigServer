-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:39:48
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:43:26
-- FilePath     : /BigServer/Service/Agent/Main.lua
-- Description  : Agent服务入口 -- 一个Agent对应一个Client
-- -----------------------------

local skynet = require "skynet"
local socket = require "skynet.socket"
local netpack = require "skynet.netpack"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local Cmd = require "AgentCmd"
-- require "Hall.AgentLoginCmd"
-- require "Hall.AgentHallCmd"
-- require "Hall.AgentRoomCmd"
-- require "Hall.AgentRaceCmd"

local Msg = require "AgentMsg"
-- require "Hall.AgentLoginMsg"
-- require "Hall.AgentHallMsg"
-- require "Hall.AgentRoomMsg"
-- require "Hall.AgentRaceMsg"

local Data = require "AgentData"

skynet.register_protocol({
  name = "client",
  id = skynet.PTYPE_CLIENT,
  pack = skynet.pack,
  unpack = netpack.tostring,
})

skynet.start(function()

  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)

  skynet.dispatch("client", function(session, source, ...)
    local msgName, msgTable = pbmap.unpack(...)
    util.log(msgName.." "..util.tabToStr(msgTable, "block"))
    -- local func = Msg[msgName]
    -- if func then
    --   func(msgTable)  -- 网关来的消息不用返回
    -- end
  end)

end)