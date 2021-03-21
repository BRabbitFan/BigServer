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

---启动DataCenter
---@param conf table 配置表
function _M.start(conf)
  util.setSvr(conf.svrName)
end

---初始化用户列表
---@param accountList table<account, true> account列表
function _M.initAccountList(accountList)
  Data.AccountList = accountList
end

---检查账户是否已被注册
---@param account string 账户
---@return integer errorCode 错误码
function _M.chkIsRegisterByAccount(account)
  if Data.AccountList[account] then
    return ERROR_CODE.BASE_SUCESS
  else
    return ERROR_CODE.BASE_FAILED
  end
end

---检查用户是否已登录
---@param uid integer uid
---@return integer errorCode 错误码
function _M.chkIsLoginByUid(uid)
  if Data.UidToAgent[uid] then
    return ERROR_CODE.BASE_SUCESS
  else
    return ERROR_CODE.BASE_FAILED
  end
end

---设置玩家已注册状态
---@param account string 账户
---@return integer errorCode 错误码
function _M.setPlayerRegister(account)
  Data.AccountList[account] = true;
  return ERROR_CODE.BASE_SUCESS
end

---设置玩家未注册状态
---@param account string 账户
---@return integer errorCode 错误码
function _M.setPlayerUnRegister(account)
  Data.AccountList[account] = nil;
  return ERROR_CODE.BASE_SUCESS
end

---设置玩家登录状态
---@param uid integer uid
---@param agent number agent地址
---@return integer errorCode 错误码
function _M.setPlayerLogin(uid, agent)
  Data.UidToAgent[uid] = agent
  return ERROR_CODE.BASE_SUCESS
end

---设置玩家登出状态
---@param uid integer uid
---@return integer errorCode 错误码
function _M.setPlayerLogout(uid)
  if not uid then
    return
  end
  Data.UidToAgent[uid] = nil
  return ERROR_CODE.BASE_SUCESS
end

---发送消息至部分在线玩家
---@param uidList list uid列表
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function _M.sendToOnlinePlayers(uidList, msgName, msgTable)
  local uidToAgent = Data.UidToAgent
  for _, uid in pairs(uidList) do
    local agent = uidToAgent[uid]
    if agent then
      skynet.send(agent, "lua", "sendToClient", msgName, msgTable)
    end
  end
end

---发送消息至所有在线玩家
---@param msgName string 消息名
---@param msgTable table 消息内容(table格式)
function _M.sendToAllOnlinePlayer(msgName, msgTable)
  for uid, agent in pairs(Data.UidToAgent) do
    skynet.send(agent, "lua", "sendToClient", msgName, msgTable)
  end
end

return _M