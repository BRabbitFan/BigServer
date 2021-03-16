-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 19:53:49
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:43:34
-- FilePath     : /BigServer/Service/Agent/AgentMsg.lua
-- Description  : 客户端的请求消息处理
-- -----------------------------

local socket = require "skynet.socket"

local pbmap = require "Util.PbMap"
local util = require "Util.BaseUtil"

local Data = require "AgentData"

local _M = {}

function _M.sendToClient(msgBytes)
  local sendBytes = string.pack(">s2", msgBytes)
  socket.write(Data.base.fd, sendBytes)
end

function _M.ReqRegisterAccount(msgTable)
  print(util.tabToStr(msgTable, "block"))
  local account = Data.account
  account.account = msgTable.account
  account.password = msgTable.password
  account.name = msgTable.name
  _M.sendToClient(pbmap.pack("RetRegisterAccount", {
    error_code = 0;
  }))
end

return _M