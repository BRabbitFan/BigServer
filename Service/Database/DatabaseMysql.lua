-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-03-13 19:41:30
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-03-16 15:39:37
-- FilePath     : /BigServer/Service/Database/DatabaseMysql.lua
-- Description  : 数据库服务--mysql相关
-- -----------------------------

local mysql = require "skynet.db.mysql"

local util = require "Util.SvrUtil"

local ERROR_CODE = require "GlobalDefine.ErrorCode"
local MYSQL_CONF = require("GameConfig/DatabaseConf").MYSQL_CONF
local MYSQL_ERRNO = require("GameConfig/DatabaseConf").MYSQL_ERRNO

local db  -- Mysql句柄

local _M = {}

---连接mysql
---@param host string ip
---@param port integer 端口
---@param database string 数据库名
---@param user string 用户名
---@param password string 密码
---@param maxPacketSize integer 最大包尺寸
function _M.getConnect(host, port, database, user, password, maxPacketSize)
  db = mysql.connect({
    host = host or MYSQL_CONF.host,
    port = port or MYSQL_CONF.port,
    database = database or MYSQL_CONF.database,
    user = user or MYSQL_CONF.user,
    password = password or MYSQL_CONF.password,
    maxPacketSize = maxPacketSize or MYSQL_CONF.maxPacketSize,
    on_connect = function(...) return ... end
  })
end

---关闭连接
function _M.disConnect()
  db:disconnect()
end

---插入新用户
---@param account string 账户
---@param password string 密码
---@return errorCode integer 错误码
---@return result table 插入结果(BASE_SUCESS) / 错误信息(未知错误)
function _M.insertUser(account, password)
  account = tostring(account)
  password = tostring(password)
  local resTab = db:query("INSERT user (account, password) VALUES (\""..account.."\", \""..password.."\");")

  if not resTab.badresult then
    return ERROR_CODE.BASE_SUCESS, resTab
  end
  if resTab.errno == MYSQL_ERRNO.DUPLICATE_ENTRY then
    return ERROR_CODE.DB_MYSQL_DUPLICATE_ENTRY
  end
  return ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB, resTab
end

---获取所有用户信息
---@return errorCode integer 错误码
---@return result table 查询结果(BASE_SUCESS) / 错误信息(未知错误)
function _M.selectAllUser()
  local resTab = db:query("SELECT * FROM user;")
  if not resTab.badresult then
    return ERROR_CODE.BASE_SUCESS, resTab
  end
  return ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB, resTab
end

---通过账户查询用户信息
---@param account string 账户
---@return errorCode integer 错误码
---@return result table 查询结果(BASE_SUCESS) / 错误信息(未知错误)
function _M.selectUserByAccount(account)
  account = tostring(account)
  local resTab = db:query("SELECT * FROM user WHERE account=\""..account.."\";")

  if not resTab.badresult then
    return ERROR_CODE.BASE_SUCESS, resTab[1]
  end
  if resTab.errno == MYSQL_ERRNO.DUPLICATE_ENTRY then
    return ERROR_CODE.DB_MYSQL_DUPLICATE_ENTRY
  end
  return ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB, resTab
end

---通过uid查询用户信息
---@param uid integer uid
---@return errorCode integer 错误码
---@return result table 查询结果(BASE_SUCESS) / 错误信息(未知错误)
function _M.selectUserByUid(uid)
  uid = tostring(uid)
  local resTab =  db:query("SELECT * FORM user WHERE uid="..uid..";")

  if not resTab.badresult then
    return ERROR_CODE.BASE_SUCESS, resTab[1]
  end
  if resTab.errno == MYSQL_ERRNO.DUPLICATE_ENTRY then
    return ERROR_CODE.DB_MYSQL_DUPLICATE_ENTRY
  end
  return ERROR_CODE.DB_MYSQL_ERROR_WITH_TAB, resTab
end

return _M