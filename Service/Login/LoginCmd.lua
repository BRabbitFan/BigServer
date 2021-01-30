-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-30 15:45:17
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 16:00:41
-- FilePath     : /BigServer/Service/Login/LoginCmd.lua
-- Description  : 登录服务--服务器指令
-- -----------------------------

local skynet = require "skynet"

local _M = {}

local watchdog

function _M.start(watchdogAddr)
  watchdog = watchdogAddr
end

---用户登录
---@param account string 用户名
---@param password string 密码
---@return integer uid 用户的uid
function _M.login(account, password)
  local uid
  return uid
end

---用户注册
---@param account string 用户名
---@param password string 密码
---@return boolean result 注册结果
---@return integer errorCode 错误码
function _M.register(account, password)
  return true, "register sucess"
end

return _M