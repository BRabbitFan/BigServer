-- -----------------------------
-- https://github.com/BRabbitFan
-- -----------------------------
-- Author       : BRabbitFan
-- Date         : 2021-01-29 20:51:39
-- LastEditer   : BRabbitFan
-- LastEditTime : 2021-01-30 14:09:42
-- FilePath     : /BigServer/Util/SvrUtil.lua
-- Description  : 服务工具模块--包括了基础模块, 需要在服务中调用
-- -----------------------------

local skynet = require "skynet.manager"

local _M = require "Util.BaseUtil"

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