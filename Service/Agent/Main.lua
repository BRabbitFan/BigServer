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

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local Cmd = require "AgentCmd"
local Msg = require "AgentMsg"

local Data = require "AgentData"

function SendToClient(msgName, msgTable)
  local msgBytes = pbmap.pack(msgName, msgTable)

  local name, table = pbmap.unpack(msgBytes)
  util.log("[Agent][Send]"..name.." "..util.tabToStr(table, "block"))

  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(Data.base.fd, sendBytes)
end

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, ...)
    local func = Cmd[cmd]
    if func then
      skynet.retpack(func(...))
    end
  end)
end)