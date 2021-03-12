-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:49
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-12 17:44:14
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

function _M.ReqRegisterAccount(msgTable)
  print(util.tabToStr(msgTable, "block"))
  local account = DATA.account
  account.account = msgTable.account
  account.password = msgTable.password
  account.name = msgTable.name
  _M.sendToClient(PbMap.pack("RetRegisterAccount", {
    error_code = 0;
  }))
end

return _M