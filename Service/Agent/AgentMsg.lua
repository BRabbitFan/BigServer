-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:49
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 00:27:21
-- FilePath     : /BigServer/Service/Agent/AgentMsg.lua
-- Description  : 客户端的请求消息处理
-- -----------------------------

local socket = require "skynet.socket"

local PbMap = require "Util.PbMap"
local util = require "Util.BaseUtil"

local DATA = require "AgentData"

local _M = {}

function _M.sendToClient(msgBytes)
  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(DATA.base.fd, sendBytes)
end

function _M.Account(msgTable)
  print(util.tabToStr(msgTable, "block"))
  local Account = {
    account = "backAccount",
    ip = "backIp",
    port = "backPort",
    addr = "backAddr",
  }
  _M.sendToClient(PbMap.pack("Account", Account))
end

function _M.Test(msgTable)
  print("_M.Test")
end

return _M