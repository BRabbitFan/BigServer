local DatabaseConf = require "GameConfig.DatabaseConf"
-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-25 22:01:50
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:14:57
-- FilePath     : /BigServer/Service/DataCenter/DataCenterCmd.lua
-- Description  : 数据中心--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"
local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Data = require "DataCenterData"

local _M = {}

function _M.start(conf)
  util.setSvr(conf.svrName)
end

---检查账户是否已被注册
---@param account string 账户
---@return errorCode integer 错误码
function _M.chkIsRegisterByAccount(account)
  if Data.AccountList[account] then
    return ERROR_CODE.BASE_SUCESS
  else
    return ERROR_CODE.BASE_FAILED
  end
end

---检查用户是否已登录
---@param uid integer uid
---@return errorCode integer 错误码
function _M.chkIsLoginByUid(uid)
  if Data.UidToAgent[uid] then
    return ERROR_CODE.BASE_SUCESS
  else
    return ERROR_CODE.BASE_FAILED
  end
end

---设置玩家已注册状态
---@param account string 账户
---@return errorCode integer 错误码
function _M.setPlayerRegister(account)
  Data.AccountList[account] = true;
  return ERROR_CODE.BASE_SUCESS
end

---设置玩家未注册状态
---@param account string 账户
---@return errorCode integer 错误码
function _M.setPlayerUnRegister(account)
  Data.AccountList[account] = nil;
  return ERROR_CODE.BASE_SUCESS
end

---设置玩家登录状态
function _M.setPlayerLogin(uid, agent)
  Data.UidToAgent[uid] = agent
  return ERROR_CODE.BASE_SUCESS
end

return _M