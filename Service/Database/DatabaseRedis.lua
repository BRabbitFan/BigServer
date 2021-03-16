-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:42:46
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:31:09
-- FilePath     : /BigServer/Service/Database/DatabaseRedis.lua
-- Description  : 数据库服务--redis相关
-- -----------------------------

local redis = require "skynet.db.redis"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local REDIS_CONF = require("GameConfig/DatabaseConf").REDIS_CONF
local KEY_HEAD = require("GameConfig/DatabaseConf").REDIS_KEY_HEAD

local db

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
---@return errorCode integer 错误码
function _M.setUidByAccount(account, uid)
  account = tostring(account)
  uid = tostring(uid)
  db:hset(KEY_HEAD.ACCOUNT_TO_UID, account, uid)
  return ERROR_CODE.BASE_SUCESS
end

---使用account获取uid
---@param account string 账号
---@return errorCode integer 错误码
---@return uid integer uid
function _M.getUidByAccount(account)
  account = tostring(account)
  local uid = db:hget(KEY_HEAD.ACCOUNT_TO_UID, account)
  return ERROR_CODE.BASE_SUCESS, uid
end

---设置玩家信息
---@param uid integer 玩家uid
---@param infoTab table 玩家信息
function _M.setUserInfo(uid, infoTab)
  local keyStr = KEY_HEAD.USER_INFO .. tostring(uid)
  local valueStr = util.tabToStr(infoTab)
  db:set(keyStr, valueStr)
  return ERROR_CODE.BASE_SUCESS
end

---获取玩家信息, 通过uid
---@param uid integer uid
---@return infoTab table 玩家信息
function _M.getUserInfoByUid(uid)
  local keyStr = KEY_HEAD.USER_INFO .. tostring(uid)
  local valueStr = db:get(keyStr)
  return ERROR_CODE.BASE_SUCESS, util.strToTab(valueStr)
end

return _M