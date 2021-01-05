-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-05 14:23:13
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-05 16:58:39
-- FilePath     : /BigServer/luacode/util/service_name.lua
-- Description  : 工具类---设置/获取服务地址
-- -----------------------------

---require------------------------------------------------------------------------------------------

local skynet = require "skynet"
require "skynet.manager"

require "conf.service_name"

---global-------------------------------------------------------------------------------------------

---工具类
---@type table<_, fun(...)>
util = util or {}

---local--------------------------------------------------------------------------------------------

---global-function----------------------------------------------------------------------------------

---设置服务别名
---@param svrName string 服务别名key(对应conf.service_name中的key)
function util.setSvr(svrName)
  skynet.register(conf.service_name[svrName])
end

---获得服务地址
---@param svrName string 服务别名key(对应conf.service_name中的key)
---@return number 服务地址
function util.getSvr(svrName)
  return skynet.localname(conf.service_name[svrName])
end

---local-function-----------------------------------------------------------------------------------
