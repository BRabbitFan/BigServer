-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:23:13
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-25 22:12:19
-- FilePath     : /BigServer/util/service_name.lua
-- Description  : 工具类---设置/获取服务地址
-- -----------------------------

local skynet = require "skynet.manager"

---工具类
---@type table<_, fun(...)>
local _M = {}

---设置服务别名
---@param svrName string 服务别名key(对应conf.service_name中的key)
function _M.setSvr(svrName)
  skynet.register(svrName)
end

---获得服务地址
---@param svrName string 服务别名key(对应conf.service_name中的key)
---@return number 服务地址
function _M.getSvr(svrName)
  return skynet.localname(svrName)
end

return _M