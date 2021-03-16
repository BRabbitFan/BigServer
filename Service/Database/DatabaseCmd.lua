-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-12 21:20:55
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:28:06
-- FilePath     : /BigServer/Service/Database/DatabaseCmd.lua
-- Description  : 数据库服务--服务命令
-- -----------------------------

local skynet = require "skynet"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"

local Data = require "DatabaseData"
local Mysql = require "DatabaseMysql"
local Redis = require "DatabaseRedis"

local _M = {}

function _M.start(conf)
  util.setSvr(conf.svrName)
  Mysql.getConnect()
  Redis.getConnect()
end

function _M.query(...)
  return Mysql.query(...)
end

function _M.set(...)
  return Redis.set(...)
end

function _M.get(...)
  return Redis.get(...)
end

function _M.setPlayerInfo(infoTab)
  local errorCode, resTab = Mysql.insertUser(infoTab.account, infoTab.password)
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

function _M.getPlayerInfoByUid(uid)
  local errorCode, resTab = Redis.getUserInfoByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  return ERROR_CODE.BASE_SUCESS, resTab
end

function _M.getPlayerInfoByAccount(account)
  local errorCode, uid = Redis.getUidByAccount(account)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return ERROR_CODE.DB_REDIS_ERROR
  end
  return _M.getPlayerInfoByUid(uid)
end

return _M