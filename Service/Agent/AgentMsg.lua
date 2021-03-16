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

local skynet = require "skynet"

local pbmap = require "Util.PbMap"
local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local SVR = require "GlobalDefine.ServiceName"

local Cmd = require "AgentCmd"
local Data = require "AgentData"

local _M = {}

function _M.ReqLoginAccount(msgTable)
  local info = msgTable.login_account
  local errorCode, totalInfo = skynet.call(SVR.login, "lua", "login", info.account, info.password)

  if errorCode == ERROR_CODE.BASE_SUCESS then
    local account = Data.account
    account.uid = totalInfo.uid
    account.account = totalInfo.account
    account.password = totalInfo.password
    account.name = totalInfo.name
  end

  Cmd.sendToClient(pbmap.pack("RetLoginAccount", {
    error_code = errorCode,
  }))
end

function _M.ReqRegisterAccount(msgTable)
  local info = msgTable.register_account
  local errorCode = skynet.call(SVR.login, "lua", "register", info.account, info.password, info.name)

  Cmd.sendToClient(pbmap.pack("RetRegisterAccount", {
    error_code = errorCode,
  }))
end

return _M