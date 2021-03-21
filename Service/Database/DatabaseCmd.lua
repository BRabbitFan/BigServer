-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:20:55
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:42:27
-- FilePath     : /BigServer/Service/Database/DatabaseCmd.lua
-- Description  : 数据库服务--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local SVR = require "GlobalDefine.ServiceName"
local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Mysql = require "DatabaseMysql"
local Redis = require "DatabaseRedis"

local _M = {}

---初始化Redis缓存
---@return integer errorCode 错误码
---@return table result 错误信息(未知错误)
local function initRedis()
  util.log("[Database][Cmd][initRedis]")
  local errorCode, resTab = Mysql.selectAllUser()
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode, resTab
  end
  local accountList = {}
  for _, info in pairs(resTab) do
    accountList[info.account] = true
    Redis.setUidByAccount(info.account, info.uid)
    Redis.setUserInfo(info.uid, info)
  end
  skynet.send(SVR.dataCenter, "lua", "initAccountList", accountList)
  return ERROR_CODE.BASE_SUCESS
end

---启动Database
---@param conf table 参数列表
function _M.start(conf)
  util.log("[Database][Cmd][start] conf->"..util.tabToStr(conf, "block"))
  util.setSvr(conf.svrName)
  Mysql.getConnect()
  Redis.getConnect()
  initRedis()
end

---设置玩家账号信息
---@param infoTab table<account|password, ...> 账号信息
---@return integer errorCode 错误码
---@return table result 查询结果(BASE_SUCESS) / 错误信息(未知错误)
function _M.setPlayerInfo(infoTab)
  util.log("[Database][Cmd][setPlayerInfo] info->"..util.tabToStr(infoTab))
  local errorCode, resTab = Mysql.insertUser(infoTab.account, infoTab.password, infoTab.name)
  if errorCode == ERROR_CODE.DB_MYSQL_DUPLICATE_ENTRY then
    return errorCode
  elseif errorCode == ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB then
    local errorMsg = "Mysql Errno : "..tostring(resTab.errno)
    return ERROR_CODE.DB_REDIS_ERROR_WITH_MSG, errorMsg
  end
  -- 获得uid
  local totalInfo
  errorCode, totalInfo = Mysql.selectUserByAccount(infoTab.account)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB, totalInfo
  end
  -- redis缓存, 用于查询
  errorCode, resTab = Redis.setUidByAccount(totalInfo.account, totalInfo.uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  errorCode, resTab = Redis.setUserInfo(totalInfo.uid, totalInfo)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  return ERROR_CODE.BASE_SUCESS
end

---获取玩家账号信息, 通过uid
---@param uid integer uid
---@return integer errorCode 错误码
---@return table infoTable 账户信息
function _M.getPlayerInfoByUid(uid)
  util.log("[Database][Cmd][getPlayerInfoByUid] uid->"..tostring(uid))
  local errorCode, resTab = Redis.getUserInfoByUid(uid)
  if errorCode == ERROR_CODE.DB_REDIS_HGET_EMPTY then
    return ERROR_CODE.DB_ACCOUNT_EMPTY
  elseif errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  return ERROR_CODE.BASE_SUCESS, resTab
end

---通过account获取玩家uid
---@param account string 账户
---@return integer errorCode 错误码
---@return integer uid uid
function _M.getUidByAccount(account)
  util.log("[Database][Cmd][getUidByAccount] account->"..tostring(account))
  local errorCode, uid = Redis.getUidByAccount(account)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  return ERROR_CODE.BASE_SUCESS, uid
end

---获取玩家账号信息, 通过账号
---@param account string 账号
---@return integer errorCode 错误码
---@return table infoTable 账户信息
function _M.getPlayerInfoByAccount(account)
  util.log("[Database][Cmd][getPlayerInfoByAccount] account->"..tostring(account))
  local errorCode, uid = _M.getUidByAccount(account)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end
  return _M.getPlayerInfoByUid(uid)
end

---更新玩家分数
---@param uid integer 玩家uid
---@param newScore integer 新分数
---@return integer errorCode 错误码
function _M.updateScore(uid, newScore)
  util.log("[Database][Cmd][updateScore] uid->"..tostring(uid).." newScore->"..tostring(newScore))
  local errorCode = Mysql.updateScore(uid, newScore)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end
  return Redis.updateScore(uid, newScore)
end

return _M