-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:23:13
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-23 16:09:42
-- FilePath     : /BigServer/util/service_name.lua
-- Description  : 工具类---设置/获取服务地址
-- -----------------------------

local skynet = require "skynet"
require "skynet.manager"

local conf = require "conf.service_name"

---工具类
---@type table<_, fun(...)>
local _M = {}

---设置服务别名
---@param svrName string 服务别名key(对应conf.service_name中的key)
function _M.setSvr(svrName)
  skynet.register(conf.service_name[svrName])
end

---获得服务地址
---@param svrName string 服务别名key(对应conf.service_name中的key)
---@return number 服务地址
function _M.getSvr(svrName)
  return skynet.localname(conf.service_name[svrName])
end

return _M