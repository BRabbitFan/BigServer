-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:42:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:37:47
-- FilePath     : /BigServer/Service/Database/DatabaseRedis.lua
-- Description  : 数据库服务--redis相关
-- -----------------------------

local redis = require "skynet.db.redis"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local REDIS_CONF = require("GameConfig/DatabaseConf").REDIS_CONF
local KEY_HEAD = require("GameConfig/DatabaseConf").REDIS_KEY_HEAD

local db  -- Redis句柄

local _M = {}

---连接redis
---@param host string ip
---@param port integer 端口
---@param dbNum integer 数据库号
---@param auth string 账号
function _M.getConnect(host, port, dbNum, auth)
  db = redis.connect({
    host = host or REDIS_CONF.host,
    port = port or REDIS_CONF.port,
    db = dbNum or REDIS_CONF.db,
    auth = auth or REDIS_CONF.auth,
  })
end

---设置account->uid映射
---@param account string 账号
---@param uid integer uid
---@return integer errorCode 错误码
function _M.setUidByAccount(account, uid)
  account = tostring(account)
  uid = tostring(uid)
  db:hset(KEY_HEAD.ACCOUNT_TO_UID, account, uid)
  return ERROR_CODE.BASE_SUCESS
end

---使用account获取uid
---@param account string 账号
---@return integer errorCode 错误码
---@return integer uid uid
function _M.getUidByAccount(account)
  account = tostring(account)
  local uid = db:hget(KEY_HEAD.ACCOUNT_TO_UID, account)
  if not uid then
    return ERROR_CODE.DB_REDIS_HGET_EMPTY
  end
  return ERROR_CODE.BASE_SUCESS, tonumber(uid)
end

---设置玩家信息
---@param uid integer 玩家uid
---@param infoTab table 玩家信息
---@return table errorCode 错误码
function _M.setUserInfo(uid, infoTab)
  local keyStr = KEY_HEAD.USER_INFO .. tostring(uid)
  local valueStr = util.tabToStr(infoTab)
  db:set(keyStr, valueStr)
  return ERROR_CODE.BASE_SUCESS
end

---获取玩家信息, 通过uid
---@param uid integer uid
---@return integer errorCode 错误码
---@return table infoTab 玩家信息
function _M.getUserInfoByUid(uid)
  local keyStr = KEY_HEAD.USER_INFO .. tostring(uid)
  local valueStr = db:get(keyStr)
  if not valueStr then
    return ERROR_CODE.DB_REDIS_GET_EMPTY
  end
  return ERROR_CODE.BASE_SUCESS, util.strToTab(valueStr)
end

---更新玩家分数
---@param uid integer uid
---@param newScore integer 新分数
---@return integer errorCode 错误码
function _M.updateScore(uid, newScore)
  local errorCode, info = _M.getUserInfoByUid(uid)
  if errorCode ~= ERROR_CODE.BASE_SUCESS then
    return errorCode
  end

  info.score = newScore
  return _M.setUserInfo(uid, info)
end

return _M